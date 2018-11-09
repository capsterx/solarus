"""
Scraps the solarus doc to create a lua table with all api
"""
import json
import re
import requests
from html2text import HTML2Text
from bs4 import BeautifulSoup

api_doc_host = "http://www.solarus-games.org/doc/1.6/"
api_doc_root = api_doc_host + 'lua_api.html'

match_meth_name_and_args = r":([a-zA-Z0-9_]+)\(([a-zA-Z0-9 _\[\],]*)\)"

match_func_name_and_args = r"\..*\.(.*)\((.*)\)"

match_arg_name_and_type = r"^(.*)\((.*)\):"

parsed_funcs = 0
modules_parsed = 0

SPECIAL_DELIM = [("[{}[".format("=" * n), "]{}]".format("=" * n))
                 for n in range(10)]


h = HTML2Text(baseurl=api_doc_host)
h.body_width = 0

def html2text(text):
    return h.handle(text)

def type_of(v, *types):
    return any(isinstance(v, t) for t in types)


def get_delim(s):
    if '"' not in s and "\n" not in s:
        return ('"', '"')
    for op, cl in SPECIAL_DELIM:
        if op not in s and cl not in s:
            return (op, cl)
    raise ValueError("could not find delimiter for string")


def indent(s, level, prefix="  "):
    return "\n".join(
        "{}{}".format(prefix * level, l).rstrip() for l in s.split("\n"))


def to_lua(v,ind=0):
    if type_of(v, str):
        od, cd = get_delim(v)
        temp = "{}{}{}".format(od, v, cd)
    elif type_of(v, float, int):
        temp = "{}".format(v)
    elif type_of(v, dict):
        kvs = []
        for k, v in v.items():
            if v is None:
                continue
            ks = "{}".format(to_lua(k))
            if ks.startswith("["):
                ks = "[ {} ]".format(ks)
            else:
                ks = "[{}]".format(ks)
            if re.match(r'^[a-zA-Z0-9_]+$',k):
                ks = k
            else:
                print("strange key",k)
            vs = to_lua(v,ind+2)
            kvs.append(' '*ind + "{} = {}".format(ks, vs))
        temp = "{{\n{}\n{}}}".format(",\n".join(kvs),' '*ind)
    elif type_of(v, list, tuple, set):
        kvs = []
        for i, v in enumerate(v):
            ks = "[{}]".format(i + 1)
            vs = to_lua(v)
            kvs.append("{} = {}".format(ks, vs))
        temp = "{{\n{}\n}}".format(indent(",\n".join(kvs), 1))
    else:
        temp = to_lua(str(v))

    return temp

test = to_lua({'b':"test"})

def parse_args(h2_el, arg_list):
    """
    parse arguments types and return types from the doc bellow
    the given h2 header
    """
    types = []
    return_types = []
    for ul in next_siblings_with_name_until(h2_el, 'ul', 'h2'):
        for li in ul.find_all('li'):
            m = re.search(match_arg_name_and_type, li.get_text())
            if m:
                name, type_ = m.groups()
                name = name.strip()
                if "Return value" in name:
                    return_types.append(type_)
                else:
                    types.append((name, type_))
    return types, ",".join(return_types)


def make_descr_and_args(h2_el, name, args, type_):
    """
      from a function header, function name and args and type,
      create a description and tags args with type
    """
    opt_less_args = re.sub(r"[\[\]\ ]", '', args)
    arg_list = opt_less_args.split(',')
    types, ret_type = parse_args(h2_el, arg_list)
    for n, t in types:  #add types to
        t = t.replace(', optional', '')
        args = args.replace(n, f"{n}: {t}")
    descr = "".join(str(el) for el in next_siblings_until(h2_el, 'h2'))
    descr = html2text(descr)
    global parsed_funcs
    parsed_funcs += 1  # count how much methods where parsed
    return name, {
        "type": type_,
        "description": descr,
        "args": args,
        "returns": ret_type,
        "valuetype": ret_type
    }


def scrap_function(h2_el):
    """
    Gives the name and description of the function with given header
    """
    name, args = re.search(match_func_name_and_args, h2_el.get_text()).groups()
    return make_descr_and_args(h2_el, name, args, "function")
    # return {'type':'function'}


def scrap_method(h2_el):
    """
    Gives the name and description of the method with given header
    """
    name, args = re.search(match_meth_name_and_args, h2_el.get_text()).groups()
    return make_descr_and_args(h2_el, name, args, "method")


def next_siblings_until(el, tag_name, include=False):
    if include:
        yield el
    for i in el.next_siblings:
        if i.name == tag_name:
            break
        yield i


def next_siblings_with_name_until(el, tag_name, until):
    for i in el.next_siblings:
        if i.name == tag_name:
            yield i
        elif i.name == until:
            break


def find_with_text_match(el, tag, *texts):
    return (f
            for f in el.find_all(tag)
            if any(text in f.get_text()
                   for text in texts))


def next_siblings_with_name(el, tag_name):
    return (s for s in el.next_siblings if s.name == tag_name)


def scrap_functions_or_methods(t_block, to_scrap, *header_names):
    return dict([
        to_scrap(fun)
        for funs_header in find_with_text_match(t_block, 'h1', *header_names)
        for fun in next_siblings_with_name_until(funs_header, 'h2', 'h1')
    ])


def scrap_sub_classes_of(module_name, t_block):
    """
    Jump to sub classes of a super_type
    """
    print("Scrapping sub classes of", module_name)
    simple = ['entity', 'movement']
    if module_name in simple:
        sub_list = t_block.find('ul')
        for link in sub_list.find_all('a'):
            scrap_api_page(link.get('href', None), module_name)
        return
    if module_name == 'drawable':
        subs = ['surface', 'text_surface', 'sprite']
        for sub in subs:
            scrap_api_page('lua_api_' + sub + '.html', module_name)
        return
    raise Exception(f"Unknow super module {module_name}")


match_module_name = r"lua_api_(.*).html"

classes = {}
modules = {}

def scrap_api_page(api_page_addr, super_class=None):
    """
    scraps a whole module page with given address
    """
    global modules_parsed
    modules_parsed += 1

    module_name = re.search(match_module_name, api_page_addr).groups()[0]
    full_addr = api_doc_host + api_page_addr
    print('scraping', module_name)
    page = requests.get(full_addr)
    assert page.status_code == 200
    soup = BeautifulSoup(page.content, 'html.parser')
    t_block = soup.find('div', class_='textblock')
    module_descr = next_siblings_until(t_block.find('p'), "h1", True)
    module_descr = "".join([str(el) for el in module_descr])
    module_descr = html2text(module_descr)
    module_descr.replace('\n', '')

    functions = scrap_functions_or_methods(t_block, scrap_function, "Functions of")
    methods = scrap_functions_or_methods(t_block, scrap_method, "Methods of the type")
    super_methods = scrap_functions_or_methods(t_block, scrap_method, "Methods of all")
    events = scrap_functions_or_methods(t_block, scrap_method, "Events of the type", "Events of a ")
    super_events = scrap_functions_or_methods(t_block, scrap_method, "Events of all")

    class_childs = dict(methods, **super_methods, **events, **super_events)

    if super_methods:
        #We are in a super class page
        scrap_sub_classes_of(module_name, t_block)

        # class_childs = dict(class_childs)

    class_ = {
        'type': 'class',
        'description': module_descr,
        'childs': class_childs,
        'inherits': super_class
    }
    # if super_class is None:
    #     del class_['inherits']

    # hoist all classes in a top level dict
    if methods or super_methods or events or super_events:
        print(f"registering class {module_name} with {len(methods)} methods, {len(events)} events")
        classes[module_name] = class_

    if functions:
        # It's a lib with an attached class
        modules[module_name] = {
            'type': 'lib',
            'description': module_descr,
            'childs': functions,
        }


root_page = requests.get(api_doc_root)

assert (root_page.status_code == 200)

print("Root page loaded, creating soup")

root_soop = BeautifulSoup(root_page.content, "html.parser")
api_list = root_soop.find_all('ul')[1]

for link in api_list.find_all('a'):
    scrap_api_page(link.get('href', None))

sol = {'type': 'lib', 'childs': modules}
full_table = dict({'sol': sol}, **classes)

with open("solarus_lua_api.lua", "w") as f:
    luaf = to_lua(full_table)
    f.write('return ' + luaf)
print(
    f'Parsed {parsed_funcs} functions and methods and {modules_parsed} modules'
)

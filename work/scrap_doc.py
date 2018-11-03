import requests
import re
import json
import bs4
from html2text import html2text
from bs4 import BeautifulSoup

api_doc_host = "http://www.solarus-games.org/doc/1.6/"
api_doc_root = api_doc_host + 'lua_api.html'

match_meth_name_and_args = r":(.*)\((.*)\)"

match_func_name_and_args = r"\..*\.(.*)\((.*)\)"

match_arg_name_and_type = r"^(.*)\((.*)\):"

def parse_args(h2_el,arg_list):
    types = []
    return_types = []
    for ul in next_siblings_with_name_until(h2_el,'ul','h2'):
        for li in ul.find_all('li'):
            m = re.search(match_arg_name_and_type,li.get_text())
            if m:
                name, type_ = m.groups()
                name=name.strip()
                if "Return value" in name:
                    return_types.append(type_)
                else:
                    types.append((name,type_))
    return set(types), ",".join(return_types)

def make_descr_and_args(h2_el,name,args,type_):
    opt_less_args = re.sub(r"[\[\]\ ]",'',args)
    arg_list = opt_less_args.split(',')
    types, ret_type = parse_args(h2_el,arg_list)
    for n,t in types: #add types to
        args = args.replace(n,f"{n}: {t}")
    descr = "".join(str(el) for el in next_siblings_until(h2_el,'h2'))
    descr = html2text(descr)
    return name, {
        "type":type_,
        "description":descr,
        "args":args,
        "returns":ret_type,
        "valuetype":ret_type
    }

def scrap_function(h2_el):
    name,args = re.search(match_func_name_and_args,h2_el.get_text()).groups()
    return make_descr_and_args(h2_el,name,args,"function")
    # return {'type':'function'}

def scrap_method(h2_el):
    name,args = re.search(match_meth_name_and_args,h2_el.get_text()).groups()
    return make_descr_and_args(h2_el,name,args,"method")

def next_siblings_until(el,tag_name,include=False):
    if include:
        yield el
    for i in el.next_siblings:
        if i.name == tag_name:
            break
        yield i

def next_siblings_with_name_until(el,tag_name,until):
    for i in el.next_siblings:
        if i.name == tag_name:
            yield i
        elif i.name == until:
            break

def find_with_text_match(el,tag,text):
    return (f for f in el.find_all(tag) if text in f.get_text())

def next_siblings_with_name(el,tag_name):
    return (s for s in el.next_siblings if s.name == tag_name)

def scrap_api_page(api_page_addr):
    module_name = api_page_addr.split('.')[0].split('_')[-1]
    full_addr = api_doc_host + api_page_addr
    print('scraping page', full_addr)
    page = requests.get(full_addr)
    assert(page.status_code == 200)
    soup = BeautifulSoup(page.content,'html.parser')
    t_block = soup.find('div',class_='textblock')
    module_descr = next_siblings_until(t_block.find('p'),"h1",True)
    module_descr = "".join([str(el) for el in module_descr])
    module_descr = html2text(module_descr)

    childs = {}
    functions = dict([scrap_function(fun)
                 for funs_header in find_with_text_match(t_block,'h1',"Functions of")
                 for fun in next_siblings_with_name_until(funs_header,'h2','h1')])

    methods = dict([scrap_method(meth)
               for meths_header in find_with_text_match(t_block,'h1',"Methods of the type")
               for meth in next_siblings_with_name_until(meths_header,'h2','h1')])

    super_class = None
    for meth_of_all_header in find_with_text_match(t_block,'h1',"Methods of all"):
        # class is a super class
        super_methods = dict([scrap_method(meth)
                              for meth in next_siblings_with_name_until(meth_of_all_header,'h2','h1')])
        super_class = {
            'type':'class',
        }
        print("super class",module_name)
    class_ = {
        'type':'class',
        'description':module_descr,
        'childs': methods
    }
    return {
        'type':'lib',
        'description':module_descr,
        'childs':functions,
        module_name:class_
    }

root_page = requests.get(api_doc_root)

assert(root_page.status_code == 200)

print("Root page loaded, creating soup")

root_soop = BeautifulSoup(root_page.content,"html.parser")
api_list = root_soop.find_all('ul')[1]

apis = {link.get_text().split('.')[1]:scrap_api_page(link.get('href',None)) \
       for link in api_list.find_all('a')}

sol = {
    'type':'lib',
    'childs':apis
}

pp = json.dumps(sol,indent=2)
# print(pp)

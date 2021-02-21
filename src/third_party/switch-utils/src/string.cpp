#include <switch/string.hpp>
#include <string>
#include <cctype>
#include <algorithm>

namespace nswitch {
void ltrim(std::string &s) {
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](unsigned char ch) {
        return !std::isspace(ch);
    }));
}

void rtrim(std::string &s) {
    s.erase(std::find_if(s.rbegin(), s.rend(), [](unsigned char ch) {
        return !std::isspace(ch);
    }).base(), s.end());
}

void trim(std::string &s) {
    ltrim(s);
    rtrim(s);
}

std::vector<std::string>
split(
    const std::string & str,
    const char delim,
    const size_t maxTokens,
    bool trimEmpty
    )
{
    typedef std::string my_string;
    typedef typename my_string::size_type my_size_type;
    std::vector<std::string> tokens;
    if (str.empty())
    {
        return {};
    }
    my_size_type len = str.length();
    // Skip delimiters at beginning.
    my_size_type left = str.find_first_not_of(delim, 0);
    size_t i = 1;
    if (!trimEmpty && left != 0)
    {
        tokens.push_back(my_string());
        ++i;
    }
    while (i < maxTokens)
    {
        my_size_type right = str.find(delim, left);
        if (right == my_string::npos)
        {
            break;
        }
        if (!trimEmpty || right - left > 0)
        {
            tokens.push_back(str.substr(left, right - left));
            ++i;
        }
        left = right + 1;
    }
    if (left < len)
    {
        tokens.push_back(str.substr(left));
    }
    return tokens;
}
}

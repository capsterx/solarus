#include <string>
#include <vector>

namespace nswitch {
void ltrim(std::string &s);
void rtrim(std::string &s);
void trim(std::string &s);
std::vector<std::string> split(
    const std::string & str,
    const char delim,
    const size_t maxTokens = static_cast<size_t>(-1),
    const bool trimEmpty = false
    );
}

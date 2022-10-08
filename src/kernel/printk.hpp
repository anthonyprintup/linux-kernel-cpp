#pragma once

#include <string_view>

extern "C" int _printk(const char *fmt, ...);
namespace kernel {
    template<class... Arguments>
    int print(const std::string_view format, Arguments &&...arguments) noexcept {
        return _printk(format.data(), std::forward<Arguments>(arguments)...);
    }
}

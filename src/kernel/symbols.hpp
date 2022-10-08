#pragma once

#include <string_view>

namespace kernel {
    std::uintptr_t find_symbol(std::string_view symbol_name) noexcept;
}

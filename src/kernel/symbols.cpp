#include "symbols.hpp"

// https://github.com/torvalds/linux/blob/e8bc52cb8df80c31c73c726ab58ea9746e9ff734/kernel/debug/kdb/kdb_private.h#L72
struct kdb_symtab_t {
    [[maybe_unused]] unsigned long value {};
    [[maybe_unused]] const char *mod_name {};
    [[maybe_unused]] unsigned long mod_start {}, mod_end {};
    [[maybe_unused]] const char *sec_name {};
    [[maybe_unused]] unsigned long sec_start {}, sec_end {};
    [[maybe_unused]] const char *sym_name {};
    [[maybe_unused]] unsigned long sym_start {}, sym_end {};
};
extern "C" int kdbgetsymval(const char*, kdb_symtab_t*);

std::uintptr_t kernel::find_symbol(const std::string_view symbol_name) noexcept {
    kdb_symtab_t symtab {};
    if (const auto result = kdbgetsymval(symbol_name.data(), &symtab); result != 1) return {};
    return symtab.sym_start;
}

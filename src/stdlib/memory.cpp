#include <new>

namespace std { // NOLINT(cert-dcl58-cpp)
    const std::nothrow_t nothrow {};
}

#include "../kernel/types.hpp"

constexpr unsigned int GFP_KERNEL {0x400u | 0x800u | 0x40u | 0x80u};

[[nodiscard]] void *operator new(const std::size_t size) {
    return __kmalloc(size, GFP_KERNEL);
}
[[nodiscard]] void *operator new(const std::size_t size, const std::nothrow_t &) noexcept {
    return __kmalloc(size, GFP_KERNEL);
}
[[nodiscard]] void *operator new(const std::size_t size, const std::align_val_t, const std::nothrow_t &) noexcept {
    return __kmalloc(size, GFP_KERNEL);
}
[[nodiscard]] void *operator new[](const std::size_t size) {
    return __kmalloc(size, GFP_KERNEL);
}
[[nodiscard]] void *operator new[](const std::size_t size, const std::nothrow_t &) noexcept {
    return __kmalloc(size, GFP_KERNEL);
}

void operator delete(void *pointer) noexcept {
    kfree(pointer);
}
void operator delete(void *pointer, const std::nothrow_t &) noexcept {
    kfree(pointer);
}
void operator delete(void *pointer, const std::align_val_t) noexcept {
    kfree(pointer);
}
void operator delete(void *pointer, const std::align_val_t, const std::nothrow_t &) noexcept {
    kfree(pointer);
}
void operator delete[](void *pointer, const std::nothrow_t &) noexcept {
    kfree(pointer);
}
void operator delete[](void *pointer) noexcept {
    kfree(pointer);
}

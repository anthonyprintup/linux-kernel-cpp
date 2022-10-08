#include "kernel/printk.hpp"

int value {};
[[gnu::used]] struct A {
    A() noexcept {
        kernel::print("A::A() %i\n", value++);
    }
    ~A() {
        kernel::print("A::~A() %i\n", --value);
    }
} a_instance1 {}, a_instance2 {};

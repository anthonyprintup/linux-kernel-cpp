#include "object-lifetime.hpp"

#include <cstddef>

extern "C" {
    extern const ConstructorType init_array_start[];
    extern const ConstructorType init_array_end[];
    void call_constructors() noexcept {
        for (auto constructor = init_array_start; constructor != init_array_end; ++constructor)
            if (*constructor) (*constructor)();
    }

    AtExitFunctionEntry atexit_functions[AtExitFunctionEntry::maximum_function_count] {};
    std::size_t atexit_function_count {};
    [[gnu::used]] void *__dso_handle {}; // NOLINT(bugprone-reserved-identifier)

    [[gnu::used]] int __cxa_atexit(DestructorType destructor, void *object_pointer, void *dso_handle) { // NOLINT(bugprone-reserved-identifier)
        if (atexit_function_count >= AtExitFunctionEntry::maximum_function_count) return -1;
        atexit_functions[atexit_function_count++] = {
                .destructor = destructor, .object_pointer = object_pointer, .dso_handle = dso_handle};
        return 0;
    }
    [[gnu::used]] void __cxa_finalize(void *destructor_function) { // NOLINT(bugprone-reserved-identifier)
        // Destruct everything
        if (not destructor_function) {
            for (auto i {atexit_function_count}; i > 0uz; --i)
                if (const auto &entry = atexit_functions[i - 1uz];
                    entry.destructor) entry.destructor(entry.object_pointer);
            return;
        }

        // Destruct the objects associated with the destructor
        for (auto i {atexit_function_count}; i > 0uz; --i)
            if (auto &entry = atexit_functions[i - 1uz];
                entry.destructor == destructor_function) {
                entry.destructor(entry.object_pointer);
                entry.destructor = {};
            }
    }

    void call_destructors() noexcept {
        __cxa_finalize(nullptr);
    }
}

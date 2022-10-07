#pragma once

using ConstructorType = void(*)();
using DestructorType = void(*)(void*);

struct AtExitFunctionEntry {
    static constexpr auto maximum_function_count {128uz};

    DestructorType destructor {};
    void *object_pointer {};
    [[maybe_unused]] void *dso_handle {};
};

#pragma once

using size_t = unsigned long; // __kernel_size_t
using gfp_t = unsigned int;

extern "C" {
    void *__kmalloc(size_t size, gfp_t flags); // NOLINT(bugprone-reserved-identifier)
    void kfree(const void *);
}

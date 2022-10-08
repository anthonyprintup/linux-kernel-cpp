add_compile_options(
        # Disable exceptions
        -fno-exceptions
        # Disable RTTI
        -fno-rtti
        # Disable PIE to avoid "Unknown rela relocation: 42" errors with R_X86_64_REX_GOTPCRELX TODO: this is probably avoidable
        -fno-pie
        # Include kconfig
        -include ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/include/linux/kconfig.h
)

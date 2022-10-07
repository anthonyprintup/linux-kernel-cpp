# Find the kernel build directory
set(KERNEL_BUILD_DIRECTORY "" CACHE STRING "Path to the kernel build directory.")
if ("${KERNEL_BUILD_DIRECTORY}" STREQUAL "")
    execute_process(
        COMMAND uname -r
        OUTPUT_VARIABLE UNAME_R
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(KERNEL_BUILD_DIRECTORY "/lib/modules/${UNAME_R}/build")

    # Check if the directory exists
    if (NOT EXISTS ${KERNEL_BUILD_DIRECTORY})
        message(FATAL_ERROR "The kernel build directory does not exist. (${KERNEL_BUILD_DIRECTORY})")
    endif()

    # Find the makefile
    find_file(
            KERNEL_BUILD_MAKEFILE
            NAMES Makefile
            PATHS ${KERNEL_BUILD_DIRECTORY} NO_DEFAULT_PATH
    )
    if (NOT KERNEL_BUILD_MAKEFILE)
        message(FATAL_ERROR "Failed to locate the Makefile in the kernel build directory. (${KERNEL_BUILD_DIRECTORY})")
    endif()
endif()

# Use the correct architecture
include("cmake/kernel-headers/get-architecture.cmake")

if (NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/kernel-headers")
    include("cmake/kernel-headers/setup-kernel-headers.cmake")
endif()

# Set the include directories
set(KERNEL_INCLUDE_DIRECTORIES
        ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/include
        ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/include/uapi
        ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/include/generated
        ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/include/generated/uapi
        ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/arch/${PROCESSOR_ARCHITECTURE}/include
        ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/arch/${PROCESSOR_ARCHITECTURE}/include/asm
        ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/arch/${PROCESSOR_ARCHITECTURE}/include/uapi
        ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/arch/${PROCESSOR_ARCHITECTURE}/include/generated
        ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/arch/${PROCESSOR_ARCHITECTURE}/include/generated/asm
        ${CMAKE_CURRENT_BINARY_DIR}/kernel-headers/arch/${PROCESSOR_ARCHITECTURE}/include/generated/uapi
        CACHE PATH "Kernel build header include directories.")

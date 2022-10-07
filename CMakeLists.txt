cmake_minimum_required(VERSION 3.23 FATAL_ERROR)
project(kernel_development LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 23)

# Compiler options
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    include("cmake/compilers/clang-options.cmake")
    include("cmake/compilers/clang-definitions.cmake")
else()
    message(FATAL_ERROR "Project error: unsupported compiler toolchain (check CMakeLists.txt).")
endif()

# Detect platform specific information (distro, etc.)
include("cmake/platform-info.cmake")
setup_platform_info()

# Set up the kernel headers
if (PLATFORM_ID STREQUAL "Ubuntu")
    # TODO: automatically download the kernel headers
    include("cmake/kernel-headers/ubuntu.cmake")
else()
    message(FATAL_ERROR "Project error: unsupported platform (check CMakeLists.txt).")
endif()
include_directories(SYSTEM ${KERNEL_INCLUDE_DIRECTORIES})

# Binary target configuration
file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS "src/*.c" "src/*.cpp")

# Include the kernel module generator
include("cmake/add-kernel-module.cmake")

# Add a build target
add_kernel_module(kernel-module "${SOURCE_FILES}")

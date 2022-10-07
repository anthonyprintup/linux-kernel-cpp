## What?
This project is an attempt to add basic C++ support to the linux kernel.

## How?
By manually performing the required build steps we're able to write C++ and run our code in the kernel.

### Build Steps (CMakeLists.txt):
- Add compiler options (`nostdlib`, `fno-exceptions`, `fno-rtti`, ...),
- add preprocessor definitions (`__KERNEL__`, `MODULE`),
- determine the platform that's being used (kernel paths change between distros),
- locate the kernel include headers and copy them to the local project (required when modifying headers for C++ compatibility),
- include the kernel directories,
- define a build target for the kernel module;
  - define an `OBJECT library` to generate the object files which will get linked at a later stage,
  - generate a `Kbuild` file with the necessary object files and linker scripts,
  - invoke `make` to run the kernel build system.

## Why?
As a C++ enthusiast I found it difficult to use C to write kernel modules, so I decided to add some basic C++ support to the kernel using CMake.

## Supported features:
- [ ] exceptions (TODO)
- [ ] RTTI (TODO)
- [x] dynamic initializers
- [x] operator new/delete
- [ ] kernel headers in C++ code (TODO)

set(KERNEL_HEADERS_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/kernel-headers")

# Copy the required header files
execute_process(
        COMMAND ${CMAKE_COMMAND} -E copy_directory
            ${KERNEL_BUILD_DIRECTORY}/include
            ${KERNEL_HEADERS_DIRECTORY}/include
)
execute_process(
        COMMAND ${CMAKE_COMMAND} -E copy_directory
            ${KERNEL_BUILD_DIRECTORY}/arch/${PROCESSOR_ARCHITECTURE}/include
            ${KERNEL_HEADERS_DIRECTORY}/arch/${PROCESSOR_ARCHITECTURE}/include
)

# Modify header files which aren't C++ conformant
function(_replace_in_file FILE_PATH REGEX REPLACEMENT)
    if (NOT EXISTS ${FILE_PATH})
        status(FATAL_ERROR "Attempted to replace data in ${FILE_PATH} which does not exist.")
    endif()

    file(READ ${FILE_PATH} FILE_DATA)
    string(REGEX REPLACE "${REGEX}" "${REPLACEMENT}" FILE_DATA "${FILE_DATA}")
    file(WRITE ${FILE_PATH} "${FILE_DATA}")
endfunction()

# TODO: move to a file
#[[_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/stddef.h
        "enum {\n\tfalse\t= 0,\n\ttrue\t= 1\n};" "")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/types.h
        "typedef _Bool\t+bool;" "")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/init.h
        "offset_to_ptr\\(entry\\)" "reinterpret_cast<initcall_t>(offset_to_ptr(entry))")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/const.h
        "void" "int")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/list.h
        "new" "new_head")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/list.h
        "(entry|old|h)->(prev|first|pprev|next) = NULL;" "\\1->\\2 = reinterpret_cast<decltype(\\1->\\2)>(NULL);")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/list.h
        "(n|entry)->(next|prev|pprev) = LIST_POISON([0-9]+);" "\\1->\\2 = reinterpret_cast<decltype(\\1->\\2)>(LIST_POISON\\3);")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/poison.h
        "void" "char")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/build_bug.h
        "\\(\\(int\\)\\(sizeof\\(struct \\{ int\\:\\(\\-\\!\\!\\(e\\)\\)\\; \\}\\)\\)\\)"
        "0") # TODO: find a proper fix if possible
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/string.h
        "new" "replacement")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/bitmap.h
        "new" "replacement")
#[=[_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/math.h
        "#define abs" "\n#define abs_unused")]=]
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/linux/atomic/atomic-long.h
        "new" "new_value")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/asm-generic/bitops/find.h
        "NULL" "reinterpret_cast<const unsigned long*>(0)")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/asm-generic/bitops/le.h
        "NULL" "reinterpret_cast<const unsigned long*>(0)")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/asm-generic/bitops/le.h
        "test_bit\\(nr \\^ BITOP_LE_SWIZZLE, addr\\)" "test_bit(nr ^ BITOP_LE_SWIZZLE, reinterpret_cast<const unsigned long*>(addr))")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/asm-generic/bitops/le.h
        "bit\\(addr" "bit(reinterpret_cast<const unsigned long*>(addr)")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/include/asm-generic/bitops/le.h
        ", addr" ", reinterpret_cast<volatile unsigned long*>(addr)")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/arch/${PROCESSOR_ARCHITECTURE}/include/asm/bitops.h
        "\\(void \\*\\)\\(addr\\)" "reinterpret_cast<volatile char*>(addr)")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/arch/${PROCESSOR_ARCHITECTURE}/include/asm/atomic.h
        "new" "new_value")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/arch/${PROCESSOR_ARCHITECTURE}/include/asm/atomic64_64.h
        "new" "new_value")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/arch/${PROCESSOR_ARCHITECTURE}/include/asm/cmpxchg.h
        "new" "new_value")
_replace_in_file(${KERNEL_HEADERS_DIRECTORY}/arch/${PROCESSOR_ARCHITECTURE}/include/asm/string_64.h
        "(dst|src) \\+ 8" "reinterpret_cast<char*>(\\1) + 8")]]

# Generate a script to support constructors
file(WRITE ${BINARY_DIRECTORY}/init-array.lds
        "SECTIONS {\n"
        "    .init_array : {\n"
        "        init_array_start = .;\n"
        "        *(.init_array);\n"
        "        init_array_end = .;\n"
        "    }\n"
        "}\n")

if (NOT DEFINED MODULE_NAME OR
    NOT DEFINED OBJECT_FILES_DIRECTORY OR
    NOT DEFINED BINARY_DIRECTORY)
    message(FATAL_ERROR "Please provide the MODULE_NAME, OBJECT_FILES_DIRECTORY, and BINARY_DIRECTORY parameters.")
endif()

# Generate linker scripts first
include("cmake/generate-linker-scripts.cmake")

# Create a list of object files
file(GLOB_RECURSE OBJECT_FILES "${OBJECT_FILES_DIRECTORY}/*.o")

# Find the relative path to the object files (for Kbuild)
file(RELATIVE_PATH RELATIVE_OBJECTS_PATH ${BINARY_DIRECTORY} ${OBJECT_FILES_DIRECTORY})

# Write the Kbuild file
list(JOIN OBJECT_FILES " " OBJECT_FILES_FORMATTED)
string(REPLACE "${OBJECT_FILES_DIRECTORY}" "${RELATIVE_OBJECTS_PATH}" OBJECT_FILES_FORMATTED "${OBJECT_FILES_FORMATTED}")

file(WRITE ${BINARY_DIRECTORY}/Kbuild
        "# Module name: ${MODULE_NAME}.ko\n"
        "obj-m += ${MODULE_NAME}.o\n"
        "# Module objects\n"
        "${MODULE_NAME}-y := ${OBJECT_FILES_FORMATTED}\n"
        "KBUILD_LDFLAGS := -T ${BINARY_DIRECTORY}/init-array.lds\n"
)

# Create the necessary files for Kbuild
foreach(FILE_PATH ${OBJECT_FILES})
    # Get the filename components
    get_filename_component(FILE_DIRECTORY ${FILE_PATH} DIRECTORY)
    get_filename_component(FILE_NAME ${FILE_PATH} NAME)

    # Create the cmd file
    file(TOUCH ${FILE_DIRECTORY}/.${FILE_NAME}.cmd)
endforeach()

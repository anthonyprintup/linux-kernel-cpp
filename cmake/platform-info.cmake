# TODO: transition to /etc/os-release
function(setup_platform_info)
    # Locate lsb_release
    find_program(LSB_RELEASE_EXECUTABLE lsb_release)
    if (NOT LSB_RELEASE_EXECUTABLE)
        message(FATAL_ERROR "Failed to locate the lsb_release executable.")
    endif()

    # Fetch information from lsb_release
    execute_process(
            COMMAND ${LSB_RELEASE_EXECUTABLE} --short --id
            OUTPUT_VARIABLE LSB_RELEASE_ID
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
            COMMAND ${LSB_RELEASE_EXECUTABLE} --short --release
            OUTPUT_VARIABLE LSB_RELEASE_RELEASE
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
            COMMAND ${LSB_RELEASE_EXECUTABLE} --short --codename
            OUTPUT_VARIABLE LSB_RELEASE_CODENAME
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    # Set the variables
    set(PLATFORM_ID "${LSB_RELEASE_ID}" PARENT_SCOPE)
    set(PLATFORM_RELEASE "${LSB_RELEASE_RELEASE}" PARENT_SCOPE)
    set(PLATFORM_CODENAME "${LSB_RELEASE_CODENAME}" PARENT_SCOPE)
endfunction()

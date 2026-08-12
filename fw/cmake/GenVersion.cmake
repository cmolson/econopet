# SPDX-License-Identifier: CC0-1.0
# https://github.com/dlehenbauer/econopet
#
# Regenerates version.h at build time (cmake -P). The bootloader compares the
# embedded version, so each build must be unique.
#
# Required -D args: IN_FILE OUT_FILE SRC_DIR VER_MAJOR VER_MINOR VER_PATCH VER_STRING

find_package(Git QUIET)

if(GIT_FOUND)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
        WORKING_DIRECTORY ${SRC_DIR}
        OUTPUT_VARIABLE GIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
        RESULT_VARIABLE GIT_HASH_RESULT
    )
    if(NOT GIT_HASH_RESULT EQUAL 0)
        set(GIT_HASH "unknown")
    endif()

    execute_process(
        COMMAND ${GIT_EXECUTABLE} diff --quiet HEAD
        WORKING_DIRECTORY ${SRC_DIR}
        RESULT_VARIABLE GIT_DIRTY_RESULT
    )
    if(GIT_DIRTY_RESULT EQUAL 0)
        set(GIT_DIRTY 0)
    else()
        set(GIT_DIRTY 1)
    endif()
else()
    set(GIT_HASH "unknown")
    set(GIT_DIRTY 0)
endif()

# Unique per-build stamp so every build yields a distinct version.
string(TIMESTAMP BUILD_ID "%Y%m%d%H%M%S" UTC)

# version.h.in expands @PROJECT_VERSION_*@.
set(PROJECT_VERSION_MAJOR ${VER_MAJOR})
set(PROJECT_VERSION_MINOR ${VER_MINOR})
set(PROJECT_VERSION_PATCH ${VER_PATCH})
set(PROJECT_VERSION ${VER_STRING})

configure_file(${IN_FILE} ${OUT_FILE} @ONLY)
message(STATUS "firmware version: ${PROJECT_VERSION}-${GIT_HASH} (dirty=${GIT_DIRTY}) build ${BUILD_ID}")

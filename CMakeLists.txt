cmake_minimum_required(VERSION 3.3)

OPTION(BUILD_SHARED_LIBS "Select shared or static library build" ON)

# Request C++11 standard, using new CMake variables.
set (CMAKE_CXX_STANDARD 11)
set (CMAKE_CXX_STANDARD_REQUIRED True)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

set (WITH_ADDRESS_SANITIZER false CACHE BOOL "Enable address sanitizer")
set (WITH_DEBUG_VERBOSITY false CACHE BOOL "Enable verbose stdout messages")
set (default_build_type "Release")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")

if (WITH_DEBUG_VERBOSITY)
    add_definitions(-DSEEK_DEBUG)
endif ()

message (STATUS "Build type: ${CMAKE_BUILD_TYPE}")

find_package (LibUSB REQUIRED)
find_package (OpenCV REQUIRED NO_MODULE)

add_subdirectory (src)
add_subdirectory (examples)

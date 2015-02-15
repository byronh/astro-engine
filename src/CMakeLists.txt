cmake_minimum_required(VERSION 2.8.4)
project(astro-engine)

# Build configuration
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++14")

# Third-party libs
find_package(GLEW REQUIRED)
find_package(GLFW REQUIRED)
find_package(PythonLibs REQUIRED)
include_directories(${GLEW_INCLUDE_PATH})
include_directories(${GLFW_INCLUDE_DIR})
include_directories(${PYTHON_INCLUDE_DIRS})

# Core engine module
include_directories(${CMAKE_SOURCE_DIR}/core)
file(GLOB_RECURSE cpp_sources core/*.cpp core/graphics/*.cpp)
add_library(core SHARED ${cpp_sources})
target_link_libraries(core ${GLEW_LIBRARY} ${PYTHON_LIBRARIES})

# Platform abstraction layer
include_directories(${CMAKE_SOURCE_DIR}/platform)
add_library(platform SHARED platform/window.c)
target_link_libraries(platform ${GLFW_LIBRARIES} ${PYTHON_LIBRARIES})

# Main executable - for testing purposes only
set(SOURCE_FILES main.cpp)
add_executable(main ${SOURCE_FILES})
target_link_libraries(main core platform)
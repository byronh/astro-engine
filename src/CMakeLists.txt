cmake_minimum_required(VERSION 2.8.4)
project(astro-engine)

# Build configuration
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++14")

find_package(GLEW REQUIRED)
find_package(GLFW REQUIRED)
find_package(PythonLibs REQUIRED)
include_directories(${CMAKE_SOURCE_DIR})
include_directories(${GLEW_INCLUDE_PATH})
include_directories(${GLFW_INCLUDE_DIR})
include_directories(${PYTHON_INCLUDE_DIRS})


# Entity-component system
add_library(core SHARED core/entity_manager.cpp)

# Graphics system
file(GLOB_RECURSE graphics_sources graphics/*.cpp)
add_library(graphics SHARED ${graphics_sources})
target_link_libraries(graphics ${GLEW_LIBRARY})


# Main executable - for testing purposes only
set(SOURCE_FILES main.cpp)
add_executable(main ${SOURCE_FILES})
target_link_libraries(main core graphics)
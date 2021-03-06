cmake_minimum_required(VERSION 2.8.4)
project(astro-engine)

# Build configuration
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++14")

find_package(GLEW REQUIRED)
find_package(PythonLibs)
find_package(SDL2 COMPONENTS SDL2_ttf REQUIRED)
include_directories(${CMAKE_SOURCE_DIR})
include_directories(${GLEW_INCLUDE_PATH})
include_directories(${PYTHON_INCLUDE_DIR})
include_directories(${SDL2_INCLUDE_DIR})

file(GLOB_RECURSE core_sources core/*.cpp)
add_library(core SHARED ${core_sources})
target_link_libraries(core ${SDL2_LIBRARY} ${SDL2_TTF_LIBRARY})

file(GLOB_RECURSE graphics_sources graphics/*.cpp)
add_library(graphics SHARED ${graphics_sources})
target_link_libraries(graphics ${GLEW_LIBRARY})

add_executable(main main.cpp)
target_link_libraries(main core graphics ${PYTHON_LIBRARY})
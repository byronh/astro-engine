cmake_minimum_required(VERSION 2.8.4)
project(astro)

set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

find_package(GLEW REQUIRED)
find_package(GLFW REQUIRED)
find_package(PythonLibs REQUIRED)

include_directories(${GLEW_INCLUDE_PATH})
include_directories(${GLFW_INCLUDE_DIR})
include_directories(${PYTHON_INCLUDE_DIRS})

include_directories(${CMAKE_SOURCE_DIR}/graphics)
add_library(graphics SHARED graphics/gl.c)
target_link_libraries(graphics ${GLEW_LIBRARY} ${PYTHON_LIBRARIES})

include_directories(${CMAKE_SOURCE_DIR}/window)
add_library(window SHARED window/window.c)
target_link_libraries(window ${GLFW_LIBRARIES} ${PYTHON_LIBRARIES})

set(SOURCE_FILES main.c)
add_executable(main ${SOURCE_FILES})
target_link_libraries(main graphics window)
#   Shubh Khandelwal

cmake_minimum_required(VERSION 3.10)

project(CUSTOM_UNIX_SHELL)

add_subdirectory(${PROJECT_SOURCE_DIR}/../include ${PROJECT_BINARY_DIR}/include)

add_executable(SHELL main.c)

target_link_libraries(SHELL PUBLIC COMMANDS)

target_include_directories(SHELL PUBLIC
    "${PROJECT_BINARY_DIR}"
    "${PROJECT_SOURCE_DIR}/../include"
)
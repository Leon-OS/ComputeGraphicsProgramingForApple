cmake_minimum_required(VERSION 3.20)

get_filename_component(CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)
get_filename_component(CURRENT_LIST_DIR_NAME ${CURRENT_LIST_DIR} NAME)
gl_env_init_and_res(${CURRENT_LIST_DIR_NAME} Utils.cpp Utils.h main.cpp)

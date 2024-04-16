cmake_minimum_required(VERSION 3.20)

project(Chapter_02 LANGUAGES CXX)

gl_env_init(prog2 Prog2_supplemental_queryingOpenGL/main.cpp)
gl_env_init(prog2_1 Prog2_1_background/main.cpp)
gl_env_init(prog2_2 Prog2_2_point/main.cpp)
gl_env_init(prog2_3 Prog2_3_errorChecking/main.cpp)
add_subdirectory(Prog2_4_files)
add_subdirectory(Prog2_5_triangle)
add_subdirectory(Prog2_6_animation)




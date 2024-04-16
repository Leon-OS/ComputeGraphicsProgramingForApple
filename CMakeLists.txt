cmake_minimum_required(VERSION 3.20)

project(demo)

find_package(OpenGL REQUIRED)
find_library(COREFOUNDATION_LIB CoreFoundation)

find_package(glm REQUIRED)

include_directories(third_party/SOIL2/src)
file(GLOB SOIL2_FILES third_party/SOIL2/src/SOIL2/*)
add_library(SOIL2 STATIC ${SOIL2_FILES})
target_link_libraries(SOIL2 PRIVATE ${COREFOUNDATION_LIB})

macro(gl_env_init target)
    add_executable(${target} ${ARGN})
    target_link_libraries(${target} PRIVATE glew glfw OpenGL::GL glm::glm SOIL2)
    target_include_directories(${target} PUBLIC 
        /opt/homebrew/Cellar/glfw/3.4/include
        /opt/homebrew/Cellar/glew/2.2.0_1/include
        /opt/homebrew/Cellar/glm/1.0.1/include
    )
    target_link_directories(${target} PRIVATE
        /opt/homebrew/Cellar/glfw/3.4/lib
        /opt/homebrew/Cellar/glew/2.2.0_1/lib
    )
endmacro()

macro(gl_env_resource_prepare target regex)
    file(GLOB RESOURCE_FILES ${regex})
    foreach(RESOURCE_FILE  ${RESOURCE_FILES})  
        get_filename_component(RESOURCE_NAME "${RESOURCE_FILE}" NAME)  
        add_custom_command(TARGET ${target} POST_BUILD 
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${RESOURCE_FILE}"      
            $<TARGET_FILE_DIR:${target}>/${RESOURCE_NAME}  )
    endforeach()
endmacro()

macro(gl_env_init_and_res target)
    gl_env_init(${target} ${ARGN})
    gl_env_resource_prepare(${target} "*.glsl")
endmacro(gl_env_init_and_res)


# define macro first
add_subdirectory(Chapter_02_opengl)
add_subdirectory(Chapter_04_pipeline)
cmake_minimum_required(VERSION 3.20)

project(Chapter_04_pipeline)
# add_subdirectory(Prog4_1_1_plainRedCube)

file(GLOB SUBDIRS "${CMAKE_CURRENT_SOURCE_DIR}/*")# 遍历所有子目录名称并添加到项目中
foreach(SUBDIR ${SUBDIRS})
    message("-----" ${SUBDIR})
  # 获取子目录名称（不包括路径）
  get_filename_component(SUBDIR_NAME ${SUBDIR} NAME_WE)    # 检查子目录是否存在  
  if(IS_DIRECTORY ${SUBDIR})
    # 添加子目录到项目中
    # 注意：这里假设每个子目录都有自己的 CMakeLists.txt 文件
    add_subdirectory(${SUBDIR})
  endif()
endforeach()
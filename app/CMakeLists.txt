add_executable(${PROJECT_NAME} main.c)

target_include_directories(cstartlib PUBLIC include)
target_link_libraries(${PROJECT_NAME} cstartlib)

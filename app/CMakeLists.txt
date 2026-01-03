add_executable(c-start-app main.c)
set_target_properties(c-start-app PROPERTIES OUTPUT_NAME "cstart")

target_link_libraries(c-start-app cstart)

install(TARGETS c-start-app)

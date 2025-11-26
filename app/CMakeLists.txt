add_executable(c-start main.c)

target_link_libraries(c-start cstart libkcli.a)

install(TARGETS c-start)

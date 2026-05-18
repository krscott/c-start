#include "cstart.h"

#include "ktest.inc"
#include <stdlib.h>

KTEST_MAIN
{
    KTEST(t_greet_name)
    {
        char *greeting = cstart_create_greeting("Kris");
        ASSERT_TRUE(greeting);

        ASSERT_STR_EQ(greeting, "Hello, Kris!");

        free(greeting);
    }

    KTEST(t_greet_null)
    {
        char *greeting = cstart_create_greeting(NULL);
        ASSERT_TRUE(greeting);

        ASSERT_STR_EQ(greeting, "Hello, World!");

        free(greeting);
    }
}

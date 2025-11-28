#include "cstart.h"
#include <assert.h>
#include <stdio.h>

#ifdef NDEBUG
#error "Asserts are disabled in release"
#endif

static void t_sum(void)
{
    //
    assert(cstart_sum(1.0, 2.0) == 3.0);
}

#define RUN(test)                                                              \
    do                                                                         \
    {                                                                          \
        printf("Test: " #test "\n");                                           \
        fflush(stdout);                                                        \
        test();                                                                \
    } while (0)

int main(void)
{
    RUN(t_sum);

    return 0;
}

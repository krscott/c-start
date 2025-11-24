#include "cstartlib.h"
#include <stdio.h>

int main(int const argc, char const *const *argv)
{
    int err = 0;

    if (argc != 3)
    {
        err = 1;
        printf("Usage: %s INT INT\n", argv[0]);
        goto error;
    }

    if (!cstart_print_str_sum(argv[1], argv[2]))
    {
        err = 2;
    }

error:
    return err;
}

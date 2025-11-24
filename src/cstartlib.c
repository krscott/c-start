#include "cstartlib.h"

#include <assert.h>
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

static bool str2int(char const *const str, long *const out)
{
    assert(str);

    char *end = NULL;

    errno = 0;
    *out = strtol(str, &end, 10);

    assert(end);
    return (errno == 0) && (*end == '\0');
}

bool cstart_print_str_sum(char const *a, char const *b)
{
    bool ok = true;

    long ai;
    long bi;

    ok = str2int(a, &ai);
    if (!ok)
    {
        printf("Not an int: %s\n", a);
        goto error;
    }

    ok = str2int(b, &bi);
    if (!ok)
    {
        printf("Not an int: %s\n", b);
        goto error;
    }

    printf("%ld + %ld = %ld\n", ai, bi, ai + bi);

error:
    return ok;
}

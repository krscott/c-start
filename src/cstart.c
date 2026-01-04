#include "cstart.h"
#include "ktl/lib/strings.h"
#include "ktl/lib/strings.inc"
#include <assert.h>
#include <stdbool.h>
#include <stddef.h>

bool cstart_verbose = false;

// Create a greeting string.
// Allocates - client code is responsible for freeing returned pointer
cstart_nodiscard char *cstart_create_greeting(char const *const name)
{
    struct strbuf s = {0};

    strbuf_append_terminated(&s, "Hello, ");

    if (name)
    {
        strbuf_append_strview(&s, strview_trim(strview_from_terminated(name)));
    }
    else
    {
        strbuf_append_terminated(&s, "World");
    }

    strbuf_append_terminated(&s, "!");

    return s.ptr;
}

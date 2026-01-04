#include "cstart.h"
#include "cstart_macros.h"
#include "kcli.inc"
#include "ktl/lib/io.h"
#include "ktl/lib/io.inc"
#include "ktl/lib/strings.h"
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

struct opts
{
    char const *filename;
    bool verbose;
};

static struct opts opts_parse(int const argc, char const *const *const argv)
{
    struct opts opts = {0};

    KCLI_PARSE(
        argc,
        argv,
        {
            .pos_name = "file",
            .ptr_str = &opts.filename,
            .optional = true,
            .help = "File to read",
        },
        {
            .short_name = 'v',
            .long_name = "verbose",
            .ptr_flag = &opts.verbose,
            .help = "Enable extra logging",
        },
    );

    return opts;
}

int main(int const argc, char const *const *const argv)
{
    struct opts opts = opts_parse(argc, argv);
    cstart_verbose = opts.verbose;

    FILE *input_file = NULL;

    strbuf buf = strbuf_init();

    if (opts.filename)
    {
        debugf("Reading name from: %s", opts.filename);
        input_file = fopen(opts.filename, "r");
        expectf_perror(
            input_file && strbuf_append_stream(&buf, input_file),
            "%s",
            opts.filename
        );
    }
    else
    {
        debugf("No file provided. Creating generic greeting...");
    }

    if (input_file)
    {
        fclose(input_file);
    }

    char *greeting = cstart_create_greeting(buf.ptr);
    printf("%s\n", greeting);
    free(greeting);

    strbuf_deinit(&buf);
    return EXIT_SUCCESS;
}

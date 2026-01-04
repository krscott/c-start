#ifndef CSTART_H_
#define CSTART_H_

#include <stdbool.h>
#if defined(__GNUC__) || defined(__clang__)
#define cstart_nodiscard __attribute__((warn_unused_result))
#else
#define cstart_nodiscard
#endif

cstart_nodiscard char *cstart_create_greeting(char const *name);

extern bool cstart_verbose;

#endif

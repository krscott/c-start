#!/usr/bin/env sh
set -eu

cd "$(dirname "$(readlink -f -- "$0")")"

find src/ -type f -name '*.c' -exec clang-format -i {} +
find src/ -type f -name '*.h' -exec clang-format -i {} +

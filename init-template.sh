#!/usr/bin/env sh
set -eu

if [ $# -ne 1 ]; then
    echo "Usage: $(basename "$0") PROJ_NAME"
    exit 1
fi

proj="$1"

case "$proj" in
*[!A-Za-z0-9_-]* | '')
    echo "Invalid project name: $proj" >&2
    echo "Project name may only contain letters, numbers, hyphens, and underscores." >&2
    exit 1
    ;;
esac

proj_flat=$(echo "$proj" | tr -d '_' | tr -d '-')
proj_hyphen=$(echo "$proj" | tr '_' '-')
proj_underscore=$(echo "$proj" | tr '-' '_')

proj_upper=$(echo "$proj_flat" | tr '[:lower:]' '[:upper:]')

script_dir=$(CDPATH='' cd "$(dirname "$0")" && pwd -P)
cd "$script_dir"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "init-template.sh must be run from a git checkout." >&2
    exit 1
fi

git ls-files | while IFS= read -r file; do
    if [ "$file" = 'init-template.sh' ]; then
        continue
    fi

    if [ -e "$file" ]; then
        echo "Processing: $file"
        tmp="${file}.tmp.$$"
        cp "$file" "$tmp"
        sed \
            -e "s/cstart/$proj_flat/g" \
            -e "s/c-start/$proj_hyphen/g" \
            -e "s/c_start/$proj_underscore/g" \
            -e "s/CSTART/$proj_upper/g" \
            "$file" >"$tmp"
        mv "$tmp" "$file"
    fi
done

echo "Renaming files"
mv include/cstart.h "include/${proj_flat}.h"
mv include/cstart_macros.h "include/${proj_flat}_macros.h"
mv src/cstart.c "src/${proj_flat}.c"
mv test/cstart_test.c "test/${proj_flat}test.c"

echo "Deleting init script"
rm .github/workflows/init-template-test.yml
rm -- "$0"

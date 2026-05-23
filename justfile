set positional-arguments

export CC := env_var_or_default("CC", "clang")

default:
    just --list

# Configure cmake from scratch with mode: debug, release, or o0.
configure mode="debug":
    #!/usr/bin/env sh
    set -eu

    mode='{{ mode }}'

    rm -rf build/

    case "$mode" in
        debug)
            cmake -B build -DCMAKE_BUILD_TYPE=Debug
            ;;
        release)
            cmake -B build -DCMAKE_BUILD_TYPE=Release
            ;;
        o0)
            DISABLE_OPTIMIZATIONS=1 cmake -B build -DCMAKE_BUILD_TYPE=Debug
            ;;
        *)
            printf 'Unknown build mode: %s\nExpected one of: debug, release, o0\n' "$mode" >&2
            exit 1
            ;;
    esac

# Build, configuring debug first if needed.
build:
    if [ ! -d build ]; then just configure; fi
    cmake --build build
    if [ -f build/compile_commands.json ]; then mkdir -p .compile-db && cp build/compile_commands.json .compile-db; fi

# Build and run the app.
run *args: build
    ./build/app/cstart "$@"

# Build and run tests.
test *args: build
    ctest --test-dir build/test --output-on-failure --verbose "$@"

# Copy vscode debug/task config into place.
setup-vscode:
    mkdir -p .vscode/
    cp dev/vscode/* .vscode/

# Format files, or all tracked files when no files are provided.
format *files:
    #!/usr/bin/env bash
    set -euo pipefail

    declare -a files=()

    if (($# == 0)); then
        mapfile -t files < <(git ls-files)
    else
        files=("$@")
    fi

    for file in "${files[@]}"; do
        if [ ! -f "$file" ]; then
            continue
        fi

        case "$file" in
            *.c | *.h)
                clang-format -i "$file"
                ;;
            CMakeLists.txt | *.cmake)
                cmake-format -i "$file"
                ;;
            *.nix)
                nix fmt -- "$file"
                ;;
            *.sh)
                shfmt -w -i 4 "$file"
                ;;
        esac
    done

# Format staged files for git pre-commit.
pre-commit:
    #!/usr/bin/env bash
    set -euo pipefail

    declare -a staged_files
    declare -a format_files=()
    declare -A partially_staged
    file=''

    mapfile -d '' -t staged_files < <(
        git diff --cached --name-only --diff-filter=ACMR -z
    )

    while IFS= read -r -d '' file; do
        partially_staged["$file"]=1
    done < <(git diff --name-only -z)

    for file in "${staged_files[@]}"; do
        if [[ -v partially_staged["$file"] ]]; then
            continue
        fi

        format_files+=("$file")
    done

    if ((${#format_files[@]} == 0)); then
        exit 0
    fi

    just format "${format_files[@]}"
    git add -- "${format_files[@]}"

# Install a pre-commit hook that formats git-changed files.
install-hooks:
    git config core.hooksPath .githooks

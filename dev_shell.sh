cfg() {
    (
        set -eu

        rm -rf build/
        cmake -B build
    )
}

bld() {
    (
        set -eu

        if [ ! -d build ]; then
            cfg
        fi

        cmake --build build

        if [ "$CMAKE_BUILD_TYPE" = "Debug" ]; then
            mkdir -p .compile-db
            cp build/compile_commands.json .compile-db
        fi
    )
}

run() {
    (
        set -eu

        bld
        ./build/app/c-start "$@"
    )
}

crun() {
    (
        set -eu

        cfg
        run "$@"
    )
}

release() {
    unset DISABLE_OPTIMZATIONS
    unset CMAKE_BUILD_TYPE
}

debug() {
    release
    export CMAKE_BUILD_TYPE=Debug
}

o0() {
    debug
    export DISABLE_OPTIMIZATIONS=1
}

setup_vscode() {
    mkdir -p .vscode/
    cp dev/vscode/* .vscode/
}

fmt() {
    (
        set -eu

        #shellcheck disable=2016
        find . -regex '.*\.$c\|h$' -exec clang-format -i {} \;

        find . -name 'CMakeLists.txt' -exec cmake-format -i {} \;

        nix fmt .
    )
}

export CC=clang
debug

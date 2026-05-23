# c-start

My rather opinionated C project template.

To start a project with this template, run:
```
./init-template.sh new_project_name
```

It comes with some of my personal C libraries. Delete what you don't need.

Don't forget to [change](https://choosealicense.com/) the LICENSE.

## Development

Update dependencies
```
nix flake update
```

Requires CMake and a C11 compiler. A nix dev shell is available:
```
nix develop
```

Standard build
```
cmake -B build
cmake --build build
```

Useful development commands
```
# Reconfigure cmake
just configure

# Build, run, and test
just build
just run
just test

# Format all files or specific files
just format
just format src/main.c include/main.h
just pre-commit

# Configure release or unoptimized debug
just configure release
just configure o0

# Install the local pre-commit formatting hook
just install-hooks

# Setup vscode debugging
just setup-vscode
```

### Debugging

Example [`launch.json`](dev/vscode/launch.json) and 
[`tasks.json`](dev/vscode/tasks.json) files are included to debug in vscode.

Nix home-manager setup
```nix
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        llvm-vs-code-extensions.lldb-dap
        llvm-vs-code-extensions.vscode-clangd
      ];
    };
```

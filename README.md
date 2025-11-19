<div align="center">
  <h1>✨🚀 msforge 🚀✨</h1>
</div>

## Language
**English** | [简体中文](README.zh-CN.md)

## Project Introduction

`msforge` is a build framework meticulously designed for Windows MSVC or MSVC-like environments. Its core philosophy is: **to liberate developers from tedious and error-prone manual build tasks**. By providing a robust and reliable automation process, it allows you to focus on more valuable tasks—optimizing build configurations and contributing code—rather than wrestling with the intricate details of the underlying toolchain.

## Core Advantages

-   **Comprehensive Build and Compilation Support**: Not bound to any specific build system or MSVC/MSVC-like compiler. The choice of build system is entirely determined by the library's own build script. `msforge` detects required environment dependencies during initialization and automatically triggers installation if they are missing. Thus, `msforge` seamlessly integrates with mainstream build systems like CMake, Meson, Autotools, and compilers like cl, clang-cl, icx-cl, ifort, ifx, nvcc, etc.
-   **Minimal Environment Requirements**: Based on Git for Windows and a few core autotools components, it can handle Autotools projects without requiring the installation of bulky Cygwin/MSYS2.
-   **Intelligent Dependency Handling**: Built-in powerful dependency resolution and topological sorting engine ensures all dependent libraries are built in the correct order, forming a complete dependency chain.
-   **Pleasant User Experience**: Integrated with the [Rich](https://github.com/Textualize/rich) library, it provides **colorful** and intuitive real-time feedback in both the **terminal** and **log files**, making the build and installation process clear at a glance.
-   **Battle-Tested Reliability**: The `ports` directory contains a large number of tested library build scripts, encapsulating valuable experience in solving unique compilation challenges for various open-source libraries in the MSVC environment.
-   **Efficient Development Paradigm**: You only need to declare the basic metadata of a library and focus on the build logic; underlying tasks such as source code acquisition, dependency resolution, and incremental builds are handled automatically and transparently by the framework.
-   **Full Lifecycle Management**: Provides a complete set of management functions, from source code acquisition, configuration, compilation, and installation to cleanup and uninstallation, with support for flexible customization of installation paths.

`msforge` is an evolving project, and your participation is sincerely invited! If you find that a library you need is not yet supported, you are very welcome to [Submit an Issues](https://github.com/jiangjianshan/msforge/issues) or add it yourself by referring to the [Contribution Guide](#contribution-guide) below.

## Quick Start
```bash
# 1. Clone this repository
git clone https://github.com/jiangjianshan/msforge.git
cd msforge

# 2. View all commands and option descriptions
mpt --help

# 3. Compile and install all supported libraries with one click (default builds for x64 architecture)
mpt
```

To customize the installation location, use the `--<library-name>-prefix` option to specify a path for a particular library, or create a `settings.yaml` file in the root directory of `msforge`. Example content is as follows:
```yaml
prefix:
  x64-windows:
    neovim: D:\Neovim
    llvm-project: D:\LLVM
    lua: D:\Lua
    perl: D:\Perl
    ruby: D:\Ruby
    tcl: D:\Tcl
    tk: D:\Tcl
    vim: D:\Vim
  x86-windows:
```

## Usage Examples

`msforge` provides a concise and unified command-line interface. The following examples only show a small fraction of the libraries available in the `ports` directory; all library configurations and scripts can be found there.

### Installing Libraries
```bash
# Install libraries (default builds for x64 architecture)
mpt gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# Install libraries for x86 architecture
mpt --arch x86 gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

### Uninstalling Libraries
```bash
# Uninstall all libraries, a single specified library, or multiple libraries
mpt --uninstall
mpt --uninstall OpenCV
mpt --uninstall gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

### Querying Library Information
```bash
# View the installation status of all libraries, a specified library, or multiple specified libraries
mpt --list
mpt --list OpenCV
mpt --list gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# Visually display the dependency tree for all libraries, a specified library, or multiple specified libraries
mpt --dependency
mpt --dependency OpenCV
mpt --dependency gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

### Managing Library Ports
```bash
# Add or remove a library, multiple libraries (generates template)
mpt --add <new-library-name>
mpt --add <new-library-name1> <new-library-name2>
mpt --remove <existing-library-name>
mpt --remove <existing-library-name1> <existing-library-name2>
```

### Fetching Source Code Only
```bash
# Download (and extract) or clone the source code for all libraries, a specified library, or multiple specified libraries (without compiling)
mpt --fetch
mpt --fetch OpenCV
mpt --fetch gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

### Cleaning Workspace
```bash
# Clean the build logs, download cache, and source code directories for all libraries, a specified library, or multiple specified libraries (requires confirmation before proceeding)
mpt --clean
mpt --clean OpenCV
mpt --clean gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

Run `mpt --help` to see the full command list and detailed examples.

## Contribution Guide

`msforge` has successfully built a wide variety of open-source libraries. For a complete list of supported libraries, please use the `mpt --list` command. We firmly believe that every contribution makes this project better, so we sincerely thank you for any form of participation!

You can contribute in the following ways:

-   **Report Issues and Suggestions**: Report bugs or share your new ideas by [Submit an Issues](https://github.com/jiangjianshan/msforge/issues).
-   **Extend Library Support**: Follow the process below to add support for a library you need or improve the build scripts of existing libraries.

### Steps to Add a New Library

1.  **Generate Configuration Template**:
```bash
mpt --add <library-name>
```
This command will create a new library directory under `ports` and generate a basic `config.yaml` configuration file, which you can carefully adjust as needed.

2.  **Apply Patches (Optional)**: If the library requires specific fixes on Windows/MSVC, save the patch files in `.diff` format and place them in the library directory.
3.  **Write Build Script**: Create a `build.bat` (Windows) or `build.sh` (cross-platform) script in the `ports/<library-name>` directory. You can refer to the scripts of other mature libraries in the `ports` directory as examples.
4.  **Test and Submit**:
```bash
mpt <library-name>
```
After successful testing, you can submit a Pull Request containing the complete `ports/<library-name>` directory.

We recommend browsing the configurations and scripts of existing libraries in the `ports` directory before you start. Their design structure is very uniform and easy to understand, which will be a great learning process.
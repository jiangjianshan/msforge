<div align="center">
  <h1>✨🚀 msforge 🚀✨</h1>
</div>

## Language
**English** | [简体中文](./README.zh-CN.md) | [Español](./README.es.md) | [日本語](./README.ja.md)  
[한국어](./README.ko.md) | [Русский](./README.ru.md) | [Português](./README.pt-BR.md)

## Project Overview
`msforge` is a build framework specifically designed for the Windows MSVC environment. Its core value lies in transforming tedious and error-prone manual build operations into robust automated processes. This allows developers to focus on optimizing and contributing build recipes, rather than getting bogged down in the complexities of the underlying toolchain.

## Core Features
- **Multi-Build System Support**: Natively supports mainstream build systems like CMake, Meson, Autotools, etc., automatically detecting and configuring the corresponding compilation environment.
- **Minimal Environment Dependencies**: Based on Git for Windows and a minimal set of necessary autotools components, it can handle Autotools projects without requiring a full Cygwin/MSYS2 installation.
- **Intelligent Dependency Management**: Supports complex dependency resolution and topological sorting, ensuring correct build order and complete dependency chains.
- **User-Friendly Experience**: Integrates the [Rich](https://github.com/Textualize/rich) library to provide colorful terminal output, displaying build progress and status information in real-time.
- **Reliable Build Framework**: Provides a large number of validated library build scripts (in the `ports` directory), having solved numerous compilation challenges for open-source libraries under MSVC.
- **Efficient Development Workflow**: Developers only need to declare library metadata and focus on build configuration, while complex underlying operations such as downloading, dependency handling, and incremental builds are handled transparently by the framework.
- **Full Lifecycle Management**: Provides end-to-end management from source code acquisition, build installation, to cleanup and uninstallation, supporting flexible installation path configuration.

`msforge` is continuously evolving and improving. Your participation and contributions are welcome! If a library you need is not yet supported, you can [submit an issue](https://github.com/jiangjianshan/msforge/issues) or refer to the [Contribution Guide](#contribution-guide) to add it yourself.

## Quick Start
```bash
# 1. Clone the repository
git clone https://github.com/jiangjianshan/msforge.git
cd msforge

# 2. View all available commands and options
mpt --help

# 3. One-click compilation and installation of all supported libraries (builds x64 architecture by default)
mpt
```
After installation, the built libraries are ready to be used in your projects. If you prefer not to use the default installation path, you can use the `--<library-name>-prefix` option to specify a custom installation path for each library.

## Common Usage

`msforge` provides a simple and consistent command-line interface. The library names listed below are just a small subset of those available in the `ports` directory. All provided library metadata and build scripts are located in `ports`.

**Install Libraries:**
```bash
# 1. Install libraries (x64 is the default architecture)
mpt gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. Install libraries for x86 architecture
mpt --arch x86 gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Uninstall Libraries:**
```bash
# Uninstall all libraries, a single library, or multiple libraries
mpt --uninstall
mpt --uninstall OpenCV
mpt --uninstall gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**List Libraries:**
```bash
# 1. Check the installation status of all libraries, a single library, or multiple libraries
mpt --list
mpt --list OpenCV
mpt --list gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. Display a nicely rendered dependency tree for all libraries, a single library, or multiple libraries
mpt --dependency
mpt --dependency OpenCV
mpt --dependency gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Add/Remove Libraries:**
```bash
# Add or remove one or more libraries
mpt --add <new-library-name>
mpt --add <new-library-name1> <new-library-name2>
mpt --remove <existing-library-name>
mpt --remove <existing-library-name1> <existing-library-name2>
```

**Fetch/Clone Only:**
```bash
# Download (and extract) archives for all libraries, a single library, or multiple libraries, or clone source code (for Git repositories only) for all libraries, a single library, or multiple libraries
mpt --fetch
mpt --fetch OpenCV
mpt --fetch gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Clean Cache:**
```bash
# Clean log files, downloaded archives, and source directories for all libraries, a single library, or multiple libraries (with confirmation prompt)
mpt --clean
mpt --clean OpenCV
mpt --clean gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```
Run `mpt --help` to see the full list of commands and examples.

## Contribution Guide

`msforge` has successfully built a wide variety of open-source libraries and continues to expand. The complete list of supported libraries can be viewed using the `mpt --list` command. Sincere thanks for any contributions.

**You can contribute in the following ways:**
*   [Submit an Issue](https://github.com/jiangjianshan/msforge/issues): Report bugs or suggest new features.
*   [Add a New Library](#adding-a-new-library): Follow the process below to add a new library or improve an existing one.

### Adding a New Library

1.  **Generate Library Template:**
```bash
mpt --add <library-name>
```
The generated library configuration file `config.yaml` can be fine-tuned manually.

2.  **Apply Patches (Optional)**: If Windows-specific fixes are needed, create `.diff` files.
3.  **Write Build Script**: Create a `build.bat` or `build.sh` script in the `ports/<library-name>` directory, referencing existing examples.
4.  **Test and Submit:**
```bash
mpt <library-name> # Build and test
```
After successful testing, submit a Pull Request containing the `ports/<library-name>` directory.

For more details, refer to the existing library configurations in the `ports` directory.

## Resources

*   **Source Code & Library Configurations:** https://github.com/jiangjianshan/msforge
*   **Issues & Discussions:** https://github.com/jiangjianshan/msforge/issues
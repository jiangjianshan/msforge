@echo off
setlocal enabledelayedexpansion
rem
rem Build script for the current library.
rem
rem This script is designed to be invoked by `mpt.bat` using the command `mpt <library_name>`.
rem It relies on specific environment variables set by the `mpt` process to function correctly.
rem
rem Environment Variables Provided by `mpt` (in addition to system variables):
rem   ARCH          - Target architecture to build for. Valid values: `x64` or `x86`.
rem   PKG_NAME      - Name of the current library being built.
rem   PKG_VER       - Version of the current library being built.
rem   ROOT_DIR      - Root directory of the msvc-pkg project.
rem   SRC_DIR       - Source code directory of the current library.
rem   PREFIX        - **Actual installation path prefix** for the *current* library after successful build.
rem                   This path is where the built artifacts for *this specific library* will be installed.
rem                   It usually equals `_PREFIX`, but **may differ** if a non-default installation path
rem                   was explicitly specified for this library (e.g., `D:\LLVM` for `llvm-project`).
rem   PREFIX_PATH   - List of installation directory prefixes for third-party dependencies.
rem   _PREFIX       - **Default installation path prefix** for all built libraries.
rem                   This is the root directory where libraries are installed **unless overridden**
rem                   by a specific `PREFIX` setting for an individual library.
rem
rem   For each direct dependency `{Dependency}` of the current library:
rem     {Dependency}_SRC - Source code directory of the dependency `{Dependency}`.
rem     {Dependency}_VER - Version of the dependency `{Dependency}`.

call "%ROOT_DIR%\compiler.bat" %ARCH%
set BUILD_DIR=%SRC_DIR%\src
rem NOTE: Don't add '-utf-8' to build this library, otherwise will have the issue "'/utf-8' and '/source-charset:utf-8' command-line options are incompatible"
set C_OPTS=-diagnostics:column -experimental:c11atomics -fp:precise -MD -nologo -openmp:llvm
set C_DEFS=-DWIN32 -D_WIN32_WINNT=_WIN32_WINNT_WIN10 -D_CRT_DECLARE_NONSTDC_NAMES -D_CRT_SECURE_NO_DEPRECATE -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_CRT_NONSTDC_NO_WARNINGS -D_USE_MATH_DEFINES -DNOMINMAX
set CL=%C_OPTS% %C_DEFS%

call :clean_stage
call :configure_stage
call :build_stage
call :install_stage
call :clean_stage
goto :end

:clean_stage
echo "Cleaning %PKG_NAME% %PKG_VER%"
cd "%BUILD_DIR%"
nmake -f Make_mvc.mak clean
for /f "delims=" %%i in ('dir /b /a:d ^| findstr "Obj"') do rmdir /s /q %%i
exit /b 0

:build_stage
echo "Building %PKG_NAME% %PKG_VER%"
cd "%BUILD_DIR%"
if not defined GETTEXT_PREFIX set GETTEXT_PREFIX=%_PREFIX%
if not defined LIBICONV_PREFIX set LIBICONV_PREFIX=%_PREFIX%
if not defined LUA_PREFIX set LUA_PREFIX=%_PREFIX%
if not defined PERL_PREFIX set PERL_PREFIX=%_PREFIX%
if not defined RUBY_PREFIX set RUBY_PREFIX=%_PREFIX%
if not defined TCL_PREFIX set TCL_PREFIX=%_PREFIX%
if not defined SODIUM_PREFIX set SODIUM_PREFIX=%_PREFIX%
for /f "tokens=2" %%v in ('python --version 2^>nul') do (
  set "python_version=%%v"
)
for /f "delims=" %%p in ('where python 2^>nul') do (
  set "python_exe=%%p"
  set "python_root=!python_exe:\python.exe=!"
)
for /f "tokens=1,2 delims=." %%a in ("%python_version%") do (
  set "python_short_version=%%a%%b"
)
for /f "tokens=1,2 delims=." %%a in ("%LUA_VER%") do (
  set lua_short_version=%%a%%b
)
for /f "tokens=1,2 delims=." %%a in ("%PERL_VER%") do (
  set perl_short_version=%%a%%b
)
for /f "tokens=1,2 delims=." %%a in ("%RUBY_VER%") do (
  set "ruby_short_version=%%a%%b"
  set "ruby_long_version=%%a.%%b.0"
)
for /f "tokens=1,2 delims=." %%a in ("%TCL_VER%") do (
  set "tcl_short_version=%%a%%b"
  set "tcl_long_version=%%a.%%b"
)
set "GETTEXT_PATH=!GETTEXT_PREFIX!\bin"

echo "Building GUI version of %PKG_NAME% %PKG_VER%"
nmake -f Make_mvc.mak GUI=yes OLE=yes DIRECTX=yes FEATURES=HUGE IME=yes        ^
  MBYTE=yes ICONV=yes GETTEXT=yes DEBUG=no TERMINAL=yes USE_MSVCRT=yes         ^
  PYTHON3=%python_root% DYNAMIC_PYTHON3=yes PYTHON3_VER=%python_short_version% ^
  LUA=%LUA_PREFIX% DYNAMIC_LUA=yes LUA_VER=%lua_short_version%                 ^
  PERL=%PERL_PREFIX% DYNAMIC_PERL=yes PERL_VER=%perl_short_version%            ^
  RUBY=%RUBY_PREFIX% DYNAMIC_RUBY=yes RUBY_VER=%ruby_short_version%            ^
  RUBY_API_VER_LONG=%ruby_long_version% DYNAMIC_SODIUM=yes                     ^
  TCL=%TCL_PREFIX% DYNAMIC_TCL=yes TCL_VER=%tcl_short_version%                 ^
  TCL_VER_LONG=%tcl_long_version% SODIUM=%SODIUM_PREFIX% || exit 1

echo "Building Console version of %PKG_NAME% %PKG_VER%"
nmake -f Make_mvc.mak GUI=no OLE=no DIRECTX=no FEATURES=HUGE IME=yes           ^
  MBYTE=yes ICONV=yes GETTEXT=yes DEBUG=no TERMINAL=yes USE_MSVCRT=yes         ^
  PYTHON3=%python_root% DYNAMIC_PYTHON3=yes PYTHON3_VER=%python_short_version% ^
  LUA=%LUA_PREFIX% DYNAMIC_LUA=yes LUA_VER=%lua_short_version%                 ^
  PERL=%PERL_PREFIX% DYNAMIC_PERL=yes PERL_VER=%perl_short_version%            ^
  RUBY=%RUBY_PREFIX% DYNAMIC_RUBY=yes RUBY_VER=%ruby_short_version%            ^
  RUBY_API_VER_LONG=%ruby_long_version% DYNAMIC_SODIUM=yes                     ^
  TCL=%TCL_PREFIX% DYNAMIC_TCL=yes TCL_VER=%tcl_short_version%                 ^
  TCL_VER_LONG=%tcl_long_version% SODIUM=%SODIUM_PREFIX% || exit 1
echo "Building translations of %PKG_NAME% %PKG_VER%
pushd po
nmake -f Make_mvc.mak VIMRUNTIME=..\..\runtime install-all
popd
exit /b 0

:install_stage
echo "Installing %PKG_NAME% %PKG_VER%"
cd "%BUILD_DIR%"
for /f "tokens=1,2,3" %%a in ('findstr /r /c:"^#define VIM_VERSION_MAJOR" "version.h"') do (
    if "%%a"=="#define" if "%%b"=="VIM_VERSION_MAJOR" (
        set "vim_major=%%c"
    )
)
for /f "tokens=1,2,3" %%a in ('findstr /r /c:"^#define VIM_VERSION_MINOR" "version.h"') do (
    if "%%a"=="#define" if "%%b"=="VIM_VERSION_MINOR" (
        set "vim_minor=%%c"
    )
)
set "vim_major_minor=%vim_major%%vim_minor%"
set "VIM_RUNTIME_DIR=%PREFIX%\Vim%vim_major_minor%"
if not exist "vim%vim_major_minor%" mkdir "vim%vim_major_minor%"
if not exist "GvimExt64" mkdir GvimExt64
if not exist "GvimExt32" mkdir GvimExt32
rem Build both 64- and 32-bit versions of gvimext.dll for the installer
start /wait cmd /c ""%vcvarsall%" x64 && cd GvimExt && nmake -f Make_mvc.mak CPU=AMD64 WINVER=0x0A00 clean all"
copy GvimExt\gvimext.dll GvimExt\gvimext64.dll
move GvimExt\gvimext.dll GvimExt64\gvimext.dll
copy /Y GvimExt\README.txt GvimExt64\
copy /Y GvimExt\*.inf  GvimExt64\
copy /Y GvimExt\*.reg  GvimExt64\
start /wait cmd /c ""%vcvarsall%" x86 && cd GvimExt && nmake -f Make_mvc.mak CPU=i386 WINVER=0x0A00 clean all"
copy GvimExt\gvimext.dll GvimExt32\gvimext.dll
copy /Y GvimExt\README.txt GvimExt32\
copy /Y GvimExt\*.inf  GvimExt32\
copy /Y GvimExt\*.reg  GvimExt32\
copy /Y ..\README.txt ..\runtime
copy /Y ..\vimtutor.bat ..\runtime
copy /Y *.exe ..\runtime\
copy /Y xxd\*.exe ..\runtime
copy /Y tee\*.exe ..\runtime
mkdir ..\runtime\GvimExt64
mkdir ..\runtime\GvimExt32
copy /Y GvimExt64\*.*  ..\runtime\GvimExt64\
copy /Y %GETTEXT_PREFIX%\bin\iconv-2.dll  ..\runtime\GvimExt64\
copy /Y %GETTEXT_PREFIX%\bin\intl-8.dll  ..\runtime\GvimExt64\
copy /Y GvimExt32\*.*  ..\runtime\GvimExt32\
copy /Y %GETTEXT_PREFIX:x64=x86%\bin\iconv-2.dll      ..\runtime\GvimExt32\
copy /Y %GETTEXT_PREFIX:x64=x86%\bin\intl-8.dll       ..\runtime\GvimExt32\
copy /Y %GETTEXT_PREFIX%\bin\iconv-2.dll   ..\runtime\
copy /Y %GETTEXT_PREFIX%\bin\intl-8.dll    ..\runtime\
cd "%SRC_DIR%"
echo Copying the "runtime" files into "Vim%vim_major_minor%"
xcopy /Y /E /V /I /H /R /Q runtime\* "%VIM_RUNTIME_DIR%"
echo Copy the new binaries into the "Vim%vim_major_minor%" directory
copy /Y src\*.exe %VIM_RUNTIME_DIR%
copy /Y src\tee\tee.exe %VIM_RUNTIME_DIR%
copy /Y src\xxd\xxd.exe %VIM_RUNTIME_DIR%
rem To install the "Edit with Vim" popup menu, you need both 32-bit and 64-bit
rem versions of gvimext.dll.  They should be copied to "Vim91\GvimExt32" and
rem "Vim91\GvimExt64" respectively
if not exist %VIM_RUNTIME_DIR%\GvimExt32 (
  mkdir %VIM_RUNTIME_DIR%\GvimExt32
)
copy /Y src\GvimExt32\gvimext.dll %VIM_RUNTIME_DIR%\GvimExt32
if not exist %VIM_RUNTIME_DIR%\GvimExt64 (
  mkdir %VIM_RUNTIME_DIR%\GvimExt64
)
copy /Y src\GvimExt64\gvimext.dll %VIM_RUNTIME_DIR%\GvimExt64
rem Copy gettext and iconv DLLs into the "Vim91" directory
rem See above, they have been done when copy the content from runtime folder
if not exist "%PREFIX%\vimfiles" mkdir %PREFIX%\vimfiles
cd "%VIM_RUNTIME_DIR%"
install -create-batfiles -install-popup -install-openwith -add-start-menu -install-icons -create-directories vim
del /s /q "C:\Users\Public\Desktop\gVim Read only %vim_major%.%vim_minor%.lnk"
del /s /q "C:\Users\Public\Desktop\gVim Easy %vim_major%.%vim_minor%.lnk"
exit /b 0

:end

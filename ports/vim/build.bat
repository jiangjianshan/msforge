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
set C_OPTS=-nologo -MD -diagnostics:column -wd4819 -wd4996 -fp:precise -openmp:llvm -Zc:__cplusplus -experimental:c11atomics
set C_DEFS=-DWIN32 -D_WIN32_WINNT=_WIN32_WINNT_WIN10 -D_CRT_DECLARE_NONSTDC_NAMES -D_CRT_SECURE_NO_DEPRECATE -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_CRT_NONSTDC_NO_WARNINGS -D_USE_MATH_DEFINES -DNOMINMAX
set CL=-MP %C_OPTS% %C_DEFS%

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
exit /b 0

:install_stage
echo "Installing %PKG_NAME% %PKG_VER%"
for /f "tokens=1,2 delims=." %%a in ("%PKG_VER%") do (
  set vim_short_version=%%a%%b
)
cd %SRC_DIR%
if not exist "vim!vim_short_version!" mkdir "vim!vim_short_version!"
echo Step A: Copying the "runtime" files into "vim!vim_short_version!"
xcopy /F /Y /S runtime\* "vim!vim_short_version!"

echo Step B: Copy the new binaries into the "vim!vim_short_version!" directory
echo F | xcopy /F /Y src\*.exe "vim!vim_short_version!"
echo F | xcopy /F /Y src\tee\tee.exe "vim!vim_short_version!"
echo F | xcopy /F /Y src\xxd\xxd.exe "vim!vim_short_version!"
rem To install the "Edit with Vim" popup menu, you need both 32-bit and 64-bit
rem versions of gvimext.dll.  They should be copied to "vim91\GvimExt32" and
rem "Vim91\GvimExt64" respectively
start /wait cmd /c ""%vcvarsall%" x64 && cd GvimExt && nmake -f Make_mvc.mak CPU=AMD64 WINVER=_WIN32_WINNT_WIN10 clean all"
if not exist "vim!vim_short_version!\GvimExt64" (
  mkdir "vim!vim_short_version!\GvimExt64"
)
echo F | xcopy /F /Y src\GvimExt\gvimext.dll "vim!vim_short_version!\GvimExt64"
pushd src\GvimExt
del /s *.dll *.obj
popd
start /wait cmd /c ""%vcvarsall%" x86 && cd GvimExt && nmake -f Make_mvc.mak CPU=i386 WINVER=_WIN32_WINNT_WIN10 clean all"
if not exist "vim!vim_short_version!\GvimExt32" (
  mkdir "vim!vim_short_version!\GvimExt32"
)
echo F | xcopy /F /Y src\GvimExt\gvimext.dll "vim!vim_short_version!\GvimExt32"
echo Step C: Copy gettext and iconv DLLs into the "vim!vim_short_version!" directory
echo F | xcopy /F /Y "!GETTEXT_PREFIX:x86=x64!\bin\intl-8.dll" "vim!vim_short_version!\GvimExt64"
echo F | xcopy /F /Y "!LIBICONV_PREFIX:x86=x64!\bin\iconv-2.dll" "vim!vim_short_version!\GvimExt64"
echo F | xcopy /F /Y "!GETTEXT_PREFIX:x64=x86!\bin\intl-8.dll" "vim!vim_short_version!\GvimExt32"
echo F | xcopy /F /Y "!LIBICONV_PREFIX:x64=x86!\bin\iconv-2.dll" "vim!vim_short_version!\GvimExt32"
echo Step D: Move the "vim!vim!vim_short_version!" directory into the Vim installation subdirectory
if not exist "%PREFIX%\vim!vim_short_version!" (
  mkdir "%PREFIX%\vim!vim_short_version!"
)
xcopy /F /Y /S vim!vim_short_version! "%PREFIX%\vim!vim_short_version!"
rmdir /s /q vim!vim_short_version!
exit /b 0

:end

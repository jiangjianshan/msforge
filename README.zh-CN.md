<div align="center">
  <h1>✨🚀 msforge 🚀✨</h1>
</div>

## 语言
[English](README.md) | **简体中文**

## 项目简介

`msforge` 是一款专为 Windows MSVC 或类 MSVC 环境精心设计的构建框架。核心理念是：**将开发者从繁琐易错的手动构建工作中解放出来**。它通过提供一套健壮、可靠的自动化流程，让您能专注于更具价值的任务——优化构建配置和贡献代码，而非纠缠于底层工具链的复杂细节。

## 核心优势

-   **全面的构建和编译支持**：不绑定任何构建系统以及任何MSVC/MSVC-like编译器，使用哪种构建系统完全由库的编译脚本自身决定选择，`msforge`会在初始化时检测所需的环境依赖，若缺失会自动触发安装流程。因此 `msforge` 可无缝衔接 CMake、Meson、Autotools 等主流构建系统和cl、clang-cl、icx-cl、ifort、ifx、nvcc等编译器
-   **极简的环境需求**：基于 Git for Windows 和少量核心的 autotools 组件，无需安装庞大的 Cygwin/MSYS2 即可处理 Autotools 项目。
-   **智能的依赖处理**：内置强大的依赖关系解析与拓扑排序引擎，确保所有依赖库均按正确顺序构建，形成完整的依赖链。
-   **愉悦的用户体验**：集成 [Rich](https://github.com/Textualize/rich) 库，在 **终端** 以及 **日志文件** 中提供 **色彩丰富** 、信息直观的实时反馈，让构建和编译安装过程一目了然。
-   **经过实战检验的可靠性**：`ports` 目录下包含了大量经过测试的库编译脚本，凝聚了解决众多开源库在 MSVC 环境下独特编译难题的宝贵经验。
-   **高效的开发范式**：您只需声明库的基本元数据并专注于构建逻辑，繁琐的源码获取、依赖解决和增量构建等底层工作均由框架自动、透明地完成。
-   **完整的生命周期管理**：提供从源码获取、配置、编译、安装到清理卸载的全套管理功能，并支持灵活的定制化安装路径。

`msforge` 是一个在持续进化的项目，诚挚邀请您的加入！如果您发现需要的库尚未被支持，非常欢迎您 [提交 Issue](https://github.com/jiangjianshan/msforge/issues) 或参照下方的 [贡献指南](#贡献指南) 亲手添加。

## 快速入门
```bash
# 1. 克隆本仓库
git clone https://github.com/jiangjianshan/msforge.git
cd msforge

# 2. 查看所有命令和选项说明
mpt --help

# 3. 一键编译并安装所有已支持的库（默认构建 x64 架构）
mpt
```

若需自定义安装位置，可使用 `--<库名>-prefix` 选项为特定库指定路径, 或者在 `msforge` 的根目录下创建一个settings.yaml的文件，内容示例如下：
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

## 使用示例

`msforge` 提供了一套简洁统一的命令行接口。以下示例仅展示了 `ports` 目录中可用库的一小部分，所有库的配置与脚本均可在该目录中找到。

### 安装库
```bash
# 安装库（默认构建 x64 架构）
mpt gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 为 x86 架构安装库
mpt --arch x86 gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

### 卸载库
```bash
# 卸载所有库、指定单个库或多个库
mpt --uninstall
mpt --uninstall OpenCV
mpt --uninstall gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

### 查询库信息
```bash
# 查看所有库、指定一个库、指定多个库的安装状态
mpt --list
mpt --list OpenCV
mpt --list gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 以可视化的方式显示所有库、指定一个库、指定多个库的依赖关系树
mpt --dependency
mpt --dependency OpenCV
mpt --dependency gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

### 管理库端口
```bash
# 添加或移除一个库、多个库（生成模板）
mpt --add <新库名称>
mpt --add <新库名称1> <新库名称2>
mpt --remove <已有库名称>
mpt --remove <已有库名称1> <已有库名称2>
```

### 仅获取源码
```bash
# 下载（并解压）或克隆所有库、指定一个库、指定多个库的源代码（不进行编译）
mpt --fetch
mpt --fetch OpenCV
mpt --fetch gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

### 清理工作区
```bash
# 清理所有库、指定一个库、指定多个库的编译日志、下载缓存和源码目录（操作前需确认）
mpt --clean
mpt --clean OpenCV
mpt --clean gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

运行 `mpt --help` 可查看完整的命令列表和详细示例。

## 贡献指南

`msforge` 已经成功构建了种类繁多的开源库，完整的支持库列表请通过 `mpt --list` 命令查看。深信每一个贡献都能让这个项目变得更好，因此由衷感谢您的任何形式的参与！

您可以通过以下方式贡献力量：

-   **反馈问题与建议**：通过 [提交 Issue](https://github.com/jiangjianshan/msforge/issues) 来报告错误或分享您的新想法。
-   **扩展库的支持**：参考以下流程，为您需要的库添加支持或改进现有库的构建脚本。

### 添加新库的步骤

1.  **生成配置模板**：
```bash
mpt --add <库名称>
```
此命令会在 `ports` 目录下创建新的库目录并生成基础的 `config.yaml` 配置文件，您可以根据需要仔细调整该文件。

2.  **应用补丁（可选）**：如果该库在 Windows/MSVC 上需要特定的修复，请将补丁文件保存为 `.diff` 格式并放置在库目录下。
3.  **编写构建脚本**：在 `ports/<库名称>` 目录中创建 `build.bat` (Windows) 或 `build.sh` (跨平台) 脚本。您可以参考 `ports` 目录下其他成熟库的脚本作为范例。
4.  **测试与提交**：
```bash
mpt <库名称>
```
测试通过后，即可提交一个包含 `ports/<库名称>` 完整目录的 Pull Request。

我们建议在开始前，先浏览 `ports` 目录中现有库的配置和脚本，它们的设计结构非常统一且易于理解，这将是很好的学习过程。
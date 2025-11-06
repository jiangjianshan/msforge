<div align="center">
  <h1>✨🚀 msforge 🚀✨</h1>
</div>

## 语言选择
[English](./README.md) | **简体中文** | [Español](./README.es.md) | [日本語](./README.ja.md)  
[한국어](./README.ko.md) | [Русский](./README.ru.md) | [Português](./README.pt-BR.md)

## 项目概述
`msforge` 是一个专为 Windows MSVC 环境设计的构建框架，其核心价值在于将琐碎易错的手动构建操作转化为稳健的自动化流程。这使开发者能专注于构建配方的优化与贡献，而非深陷于底层工具链的复杂性。

## 核心特性
- **多构建系统支持**：原生支持 CMake、Meson、Autotools 等主流构建系统，自动检测并配置相应的编译环境。
- **最小化环境依赖**：基于 Git for Windows 及少量必要的autotools组件，无需完整 Cygwin/MSYS2 即可处理 Autotools 项目。
- **智能依赖管理**：支持复杂的依赖关系解析和拓扑排序，确保正确的构建顺序和完整的依赖链。
- **友好的用户体验**：集成 [Rich](https://github.com/Textualize/rich) 库提供色彩丰富的终端输出，实时显示构建进度和状态信息。
- **可靠的构建框架**：提供大量经过验证的库构建脚本（在`ports`里），已解决了众多开源库在 MSVC 下的编译难题。
- **高效的开发流程**：开发者只需声明库的元信息并重点关注构建配置，而复杂的下载、依赖处理、增量构建等底层操作均由框架透明化处理。
- **完整的生命周期管理**：提供从源码获取、构建安装到清理卸载的全流程管理，支持灵活的安装路径配置。

`msforge` 正在持续发展和完善，欢迎您的参与和贡献！如果您需要的库尚未支持，可以 [提交问题](https://github.com/jiangjianshan/msforge/issues) 或参考 [贡献指南](#贡献指南) 亲自添加。

## 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/jiangjianshan/msforge.git
cd msforge

# 2. 查看所有可用命令和选项
mpt --help

# 3. 一键编译安装所有支持的库（默认构建 x64 架构）
mpt
```
安装完成后，构建好的库即可在您的项目中使用。若不想使用默认安装路径，您可以使用 `--<库名>-prefix` 选项为每个库指定自定义安装路径。

## 常用方法

`msforge` 提供了简单一致的命令行界面。以下所列库名称仅为 `ports` 里的很小一部分，所有已提供的库元信息和库构建脚本均在 `ports` 里。

**安装库：**
```bash
# 1. 安装库（x64 为默认架构）
mpt gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. 为 x86 架构安装库
mpt --arch x86 gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**卸载库：**
```bash
# 卸载所有库、单个库或多个库
mpt --uninstall
mpt --uninstall OpenCV
mpt --uninstall gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**查看库：**
```bash
# 1. 查看所有库、单个库或多个库的安装状态
mpt --list
mpt --list OpenCV
mpt --list gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. 显示所有库、单个库或多个库的依赖树的漂亮渲染
mpt --dependency
mpt --dependency OpenCV
mpt --dependency gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```
**添加/删除库：**
```bash
# 添加或删除1个或多个库
mpt --add <新库名称>
mpt --add <新库名称1> <新库名称2>
mpt --remove <已有库名称>
mpt --remove <已有库名称1> <已有库名称2>
```

**仅下载/克隆：**
```bash
# 下载所有库、单个库或多个库的压缩包及解压, 或克隆(仅针对Git仓库)所有库、单个库及多个库的源码
mpt --fetch
mpt --fech OpenCV
mpt --fetch gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**清理缓存：**
```bash
# 询问清楚所有库、单个库或多个库的日志文件、压缩包及源码目录
mpt --clean
mpt --clean OpenCV
mpt --clean gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```
运行 `mpt --help` 查看完整的命令列表和示例。

## 贡献指南

`msforge` 已成功构建了大量不同类型的开源库，并仍在持续扩展中。完整的支持库清单可通过 `mpt --list` 命令查看。真诚感谢您的任何贡献。

**您可以通过以下方式参与贡献：**
*   [提交问题](https://github.com/jiangjianshan/msforge/issues): 报告错误或提出新功能建议。
*   [添加新库](#添加新库): 参考以下流程添加新库或改进现有库。

### 添加新库

1.  **生成库模板：**
    ```bash
    mpt --add <库名>
    ```
    生成的库配置文件 `config.yaml` 可手动微调

2.  **应用补丁（可选）**：如需 Windows 特定修复，可创建 `.diff` 文件。
3.  **编写构建脚本**：在 `ports/<库名>` 目录下创建 `build.bat` 或 `build.sh`，可参考现有示例。
4.  **测试与提交：**
    ```bash
    mpt <库名> # 构建并测试
    ```
    测试通过后，提交一个包含 `ports/<库名>` 目录的 Pull Request 即可。

更多细节请参考 `ports` 目录中的现有库配置。

## 资源

*   **源代码与库配置:** https://github.com/jiangjianshan/msforge
*   **问题与讨论:** https://github.com/jiangjianshan/msforge/issues

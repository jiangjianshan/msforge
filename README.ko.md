<div align="center">
  <h1>✨🚀 msforge 🚀✨</h1>
</div>

## 언어 선택
[English](./README.md) | [简体中文](./README.zh-CN.md) | [Español](./README.es.md) | [日本語](./README.ja.md)  
**한국어** | [Русский](./README.ru.md) | [Português](./README.pt-BR.md)

## 프로젝트 개요
`msforge`는 Windows MSVC 환경을 위해 특별히 설계된 빌드 프레임워크로, 그 핵심 가치는 지루하고 오류가 발생하기 쉬운 수동 빌드 작업을 안정적인 자동화 프로세스로 전환하는 데 있습니다. 이를 통해 개발자는 빌드 레시피 최적화와 기여에 집중할 수 있으며, 저수준 툴체인의 복잡성에 깊이 빠질 필요가 없습니다.

## 핵심 기능
- **다중 빌드 시스템 지원**: CMake, Meson, Autotools 등 주요 빌드 시스템을 기본 지원하며, 해당 컴파일 환경을 자동으로 감지하고 구성합니다.
- **최소 환경 의존성**: Git for Windows 및少量의 필수 autotools 구성 요소를 기반으로 하여, 전체 Cygwin/MSYS2 없이도 Autotools 프로젝트를 처리할 수 있습니다.
- **스마트 의존성 관리**: 복잡한 의존 관계 해석 및 위상 정렬을 지원하여 올바른 빌드 순서와 완전한 의존성 체인을 보장합니다.
- **편리한 사용자 경험**: [Rich](https://github.com/Textualize/rich) 라이브러리 통합으로 다채로운 터미널 출력을 제공하며, 실시간 빌드 진행률 및 상태 정보를 표시합니다.
- **신뢰할 수 있는 빌드 프레임워크**: 검증된 다양한 라이브러리 빌드 스크립트( `ports` 내)를 제공하며, MSVC 환경에서의 많은 오픈소스 라이브러리 컴파일 문제를 이미 해결했습니다.
- **효율적인 개발 워크플로**: 개발자는 라이브러리의 메타정보를 선언하고 빌드 구성에 집중하기만 하면, 복잡한 다운로드, 의존성 처리, 증분 빌드 등의 저수준 작업은 프레임워크가 투명하게 처리합니다.
- **완전한 라이프사이클 관리**: 소스 코드 획득, 빌드 설치부터 정리 및 제거에 이르는 전 과정 관리를 제공하며, 유연한 설치 경로 구성을 지원합니다.

`msforge`는 지속적으로 발전하고 개선 중이며, 여러분의 참여와 기여를 환영합니다! 필요한 라이브러리가 아직 지원되지 않는다면, [이슈 제출](https://github.com/jiangjianshan/msforge/issues) 하거나 [기여 가이드](#기여-가이드)를 참고하여 직접 추가해 주세요.

## 빠른 시작
```bash
# 1. 저장소 클론
git clone https://github.com/jiangjianshan/msforge.git
cd msforge

# 2. 사용 가능한 모든 명령어와 옵션 확인
mpt --help

# 3. 지원되는 모든 라이브러리 일괄 컴파일 및 설치 (기본적으로 x64 아키텍처 빌드)
mpt
```
설치가 완료되면, 빌드된 라이브러리를 여러분의 프로젝트에서 바로 사용할 수 있습니다. 기본 설치 경로를 사용하지 않으려면, `--<라이브러리명>-prefix` 옵션을 사용하여 각 라이브러리마다 사용자 정의 설치 경로를 지정할 수 있습니다.

## 일반적인 사용법

`msforge`는 간단하고 일관된 명령줄 인터페이스를 제공합니다. 아래 나열된 라이브러리 이름은 `ports` 디렉토리에 있는 라이브러리의 아주 일부에 불과하며, 제공된 모든 라이브러리의 메타정보와 빌드 스크립트는 `ports` 디렉토리에 있습니다.

**라이브러리 설치:**
```bash
# 1. 라이브러리 설치 (x64가 기본 아키텍처)
mpt gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. x86 아키텍처용 라이브러리 설치
mpt --arch x86 gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**라이브러리 제거:**
```bash
# 모든 라이브러리, 단일 라이브러리 또는 여러 라이브러리 제거
mpt --uninstall
mpt --uninstall OpenCV
mpt --uninstall gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**라이브러리 확인:**
```bash
# 1. 모든 라이브러리, 단일 라이브러리 또는 여러 라이브러리의 설치 상태 확인
mpt --list
mpt --list OpenCV
mpt --list gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. 모든 라이브러리, 단일 라이브러리 또는 여러 라이브러리의 의존성 트리를 보기 좋게 렌더링하여 표시
mpt --dependency
mpt --dependency OpenCV
mpt --dependency gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**라이브러리 추가/제거:**
```bash
# 1개 또는 여러 개의 라이브러리 추가 또는 제거
mpt --add <새 라이브러리 이름>
mpt --add <새 라이브러리 이름1> <새 라이브러리 이름2>
mpt --remove <기존 라이브러리 이름>
mpt --remove <기존 라이브러리 이름1> <기존 라이브러리 이름2>
```

**다운로드/클론만 수행:**
```bash
# 모든 라이브러리, 단일 라이브러리 또는 여러 라이브러리의 압축 패키지를 다운로드 및 압축 해제하거나, (Git 저장소의 경우) 모든 라이브러리, 단일 라이브러리 또는 여러 라이브러리의 소스 코드를 클론합니다.
mpt --fetch
mpt --fetch OpenCV
mpt --fetch gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**캐시 정리:**
```bash
# 모든 라이브러리, 단일 라이브러리 또는 여러 라이브러리의 로그 파일, 압축 패키지 및 소스 코드 디렉토리를 삭제하기 전에 확인을 요청합니다.
mpt --clean
mpt --clean OpenCV
mpt --clean gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```
`mpt --help`를 실행하여 전체 명령어 목록과 예제를 확인하세요.

## 기여 가이드

`msforge`는 이미 다양한 유형의 많은 오픈소스 라이브러리를 성공적으로 빌드했으며, 지속적으로 확장되고 있습니다. 지원되는 전체 라이브러리 목록은 `mpt --list` 명령어로 확인할 수 있습니다. 여러분의 어떤 기여에도 진심으로 감사드립니다.

**다음과 같은 방법으로 기여할 수 있습니다:**
*   [이슈 제출](https://github.com/jiangjianshan/msforge/issues): 버그를 보고하거나 새로운 기능을 제안합니다.
*   [새 라이브러리 추가](#새-라이브러리-추가): 아래 절차를 참고하여 새 라이브러리를 추가하거나 기존 라이브러리를 개선합니다.

### 새 라이브러리 추가

1.  **라이브러리 템플릿 생성:**
```bash
mpt --add <라이브러리 이름>
```
생성된 라이브러리 구성 파일 `config.yaml`은 수동으로 미세 조정할 수 있습니다.

2.  **패치 적용 (선택 사항)**: Windows 특화 수정이 필요한 경우, `.diff` 파일을 생성할 수 있습니다.
3.  **빌드 스크립트 작성**: `ports/<라이브러리 이름>` 디렉토리 아래에 `build.bat` 또는 `build.sh`를 생성하며, 기존 예제를 참고할 수 있습니다.
4.  **테스트 및 제출:**
```bash
mpt <라이브러리 이름> # 빌드 및 테스트
```
테스트 통과 후, `ports/<라이브러리 이름>` 디렉토리를 포함하는 Pull Request를 제출하면 됩니다.

자세한 내용은 `ports` 디렉토리의 기존 라이브러리 구성을 참조하세요.

## 리소스

*   **소스 코드 및 라이브러리 구성:** https://github.com/jiangjianshan/msforge
*   **이슈 및 논의:** https://github.com/jiangjianshan/msforge/issues
<div align="center">
  <h1>✨🚀 msforge 🚀✨</h1>
</div>

## 言語選択
[English](./README.md) | [简体中文](./README.zh-CN.md) | [Español](./README.es.md) | **日本語**  
[한국어](./README.ko.md) | [Русский](./README.ru.md) | [Português](./README.pt-BR.md)

## プロジェクト概要
`msforge` は、Windows MSVC 環境向けに設計されたビルドフレームワークです。その核心的な価値は、煩雑でエラーが発生しやすい手動ビルド操作を、堅牢な自動化プロセスに変換することにあります。これにより、開発者は低レベルのツールチェインの複雑さに深く悩まされることなく、ビルドレシピの最適化と貢献に集中できます。

## 主な機能
- **複数ビルドシステムのサポート**: CMake、Meson、Autotools などの主流ビルドシステムをネイティブサポートし、自動検出および対応するコンパイル環境の設定を行います。
- **最小限の環境依存**: Git for Windows および少量の必須 autotools コンポーネントに基づいており、完全な Cygwin/MSYS2 がなくても Autotools プロジェクトを処理できます。
- **インテリジェントな依存関係管理**: 複雑な依存関係の解決とトポロジカルソートをサポートし、正しいビルド順序と完全な依存チェーンを保証します。
- **ユーザーフレンドリーな体験**: [Rich](https://github.com/Textualize/rich) ライブラリを統合し、カラフルなターミナル出力、ビルド進捗と状態情報のリアルタイム表示を提供します。
- **信頼性の高いビルドフレームワーク**: 多数の検証済みライブラリビルドスクリプト（`ports` 内）を提供し、MSVC 環境下での多くのオープンソースライブラリのコンパイル課題を既に解決しています。
- **効率的な開発フロー**: 開発者はライブラリのメタ情報を宣言し、ビルド設定に注力するだけで済み、複雑なダウンロード、依存関係処理、インクリメンタルビルドなどの低レベル操作はフレームワークによって透過的に処理されます。
- **完全なライフサイクル管理**: ソースコード取得、ビルドインストールからクリーンアップ、アンインストールまでの全プロセス管理を提供し、柔軟なインストールパス設定をサポートします。

`msforge` は継続的に発展および改善中です。皆様の参加と貢献を歓迎します！必要なライブラリがまだサポートされていない場合は、[イシューの投稿](https://github.com/jiangjianshan/msforge/issues) または [貢献ガイド](#貢献ガイド) を参照してご自身で追加してください。

## クイックスタート
```bash
# 1. リポジトリをクローン
git clone https://github.com/jiangjianshan/msforge.git
cd msforge

# 2. 利用可能なすべてのコマンドとオプションを表示
mpt --help

# 3. サポートされているすべてのライブラリを一括コンパイル・インストール（デフォルトは x64 アーキテクチャ）
mpt
```
インストールが完了すると、ビルドされたライブラリがプロジェクトで使用できるようになります。デフォルトのインストールパスを使用したくない場合は、`--<ライブラリ名>-prefix` オプションを使用して各ライブラリにカスタムインストールパスを指定できます。

## 一般的な使用方法

`msforge` はシンプルで一貫したコマンドラインインターフェースを提供します。以下にリストされているライブラリ名は `ports` ディレクトリ内で利用可能なごく一部です。すべての提供済みライブラリのメタ情報とビルドスクリプトは `ports` ディレクトリ内にあります。

**ライブラリのインストール:**
```bash
# 1. ライブラリをインストール（x64 がデフォルトアーキテクチャ）
mpt gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. x86 アーキテクチャ向けにライブラリをインストール
mpt --arch x86 gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**ライブラリのアンインストール:**
```bash
# すべてのライブラリ、単一ライブラリ、または複数ライブラリをアンインストール
mpt --uninstall
mpt --uninstall OpenCV
mpt --uninstall gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**ライブラリの確認:**
```bash
# 1. すべてのライブラリ、単一ライブラリ、または複数ライブラリのインストール状態を表示
mpt --list
mpt --list OpenCV
mpt --list gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. すべてのライブラリ、単一ライブラリ、または複数ライブラリの依存関係ツリーを整形して表示
mpt --dependency
mpt --dependency OpenCV
mpt --dependency gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**ライブラリの追加/削除:**
```bash
# 1つまたは複数のライブラリを追加または削除
mpt --add <新しいライブラリ名>
mpt --add <新しいライブラリ名1> <新しいライブラリ名2>
mpt --remove <既存のライブラリ名>
mpt --remove <既存のライブラリ名1> <既存のライブラリ名2>
```

**ダウンロード/クローンのみ:**
```bash
# すべてのライブラリ、単一ライブラリ、または複数ライブラリのアーカイブをダウンロード・展開、または（Git リポジトリのみ）ソースコードをクローン
mpt --fetch
mpt --fetch OpenCV
mpt --fetch gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**キャッシュのクリーンアップ:**
```bash
# すべてのライブラリ、単一ライブラリ、または複数ライブラリのログファイル、アーカイブ、ソースディレクトリをクリーンアップ（確認あり）
mpt --clean
mpt --clean OpenCV
mpt --clean gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```
完全なコマンドリストと例については、`mpt --help` を実行して確認してください。

## 貢献ガイド

`msforge` は、すでに多数のさまざまな種類のオープンソースライブラリのビルドに成功しており、現在も拡張を続けています。完全なサポートライブラリリストは `mpt --list` コマンドで確認できます。皆様のあらゆる貢献に心から感謝いたします。

**以下の方法で貢献できます:**
*   [イシューの投稿](https://github.com/jiangjianshan/msforge/issues): バグの報告や新機能の提案。
*   [新しいライブラリの追加](#新しいライブラリの追加): 以下の手順を参考に、新しいライブラリを追加するか、既存のライブラリを改善してください。

### 新しいライブラリの追加

1.  **ライブラリテンプレートの生成:**
```bash
mpt --add <ライブラリ名>
```
生成されたライブラリ設定ファイル `config.yaml` は手動で微調整できます。

2.  **パッチの適用（オプション）**: Windows 特有の修正が必要な場合は、`.diff` ファイルを作成します。
3.  **ビルドスクリプトの作成**: `ports/<ライブラリ名>` ディレクトリに `build.bat` または `build.sh` を作成します。既存の例を参考にできます。
4.  **テストとコミット:**
```bash
mpt <ライブラリ名> # ビルドしてテスト
```
テストが成功したら、`ports/<ライブラリ名>` ディレクトリを含む Pull Request を提出してください。

詳細は、`ports` ディレクトリ内の既存のライブラリ設定を参照してください。

## リソース

*   **ソースコードとライブラリ設定:** https://github.com/jiangjianshan/msforge
*   **イシューとディスカッション:** https://github.com/jiangjianshan/msforge/issues
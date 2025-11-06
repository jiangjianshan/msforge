<div align="center">
  <h1>✨🚀 msforge 🚀✨</h1>
</div>

## Idioma
[English](./README.md) | [简体中文](./README.zh-CN.md) | [Español](./README.es.md) | [日本語](./README.ja.md)  
[한국어](./README.ko.md) | [Русский](./README.ru.md) | **Português**

## Visão Geral do Projeto
`msforge` é um framework de construção projetado especificamente para ambientes Windows MSVC. Seu valor central reside em transformar operações manuais de construção, triviais e propensas a erros, em fluxos de trabalho automatizados e robustos. Isso permite que os desenvolvedores se concentrem na otimização e contribuição para as "receitas" de construção, em vez de se perderem na complexidade da cadeia de ferramentas subjacente.

## Características Principais
- **Suporte a Múltiplos Sistemas de Construção**: Suporte nativo para sistemas de construção mainstream como CMake, Meson, Autotools, etc., detectando e configurando automaticamente o ambiente de compilação correspondente.
- **Dependências de Ambiente Mínimas**: Baseado no Git for Windows e alguns componentes essenciais do autotools, capaz de processar projetos Autotools sem a necessidade de um ambiente Cygwin/MSYS2 completo.
- **Gerenciamento Inteligente de Dependências**: Suporte à resolução de dependências complexas e ordenação topológica, garantindo a sequência correta de construção e uma cadeia de dependências completa.
- **Experiência de Usuário Amigável**: Integra a biblioteca [Rich](https://github.com/Textualize/rich) para fornecer saída de terminal colorida, exibindo em tempo real o progresso e informações de estado da construção.
- **Framework de Construção Confiável**: Fornece uma vasta coleção de scripts de construção de bibliotecas testados e validados (em `ports`), já resolvendo inúmeros desafios de compilação de bibliotecas de código aberto no MSVC.
- **Fluxo de Desenvolvimento Eficiente**: Os desenvolvedores só precisam declarar os metadados da biblioteca e focar na configuração de construção, enquanto operações complexas de baixo nível como download, tratamento de dependências, construções incrementais são tratadas de forma transparente pelo framework.
- **Gerenciamento Completo do Ciclo de Vida**: Oferece gerenciamento de todo o fluxo, desde a obtenção do código-fonte, construção e instalação até a limpeza e desinstalação, com suporte à configuração flexível do caminho de instalação.

O `msforge` está em contínuo desenvolvimento e aprimoramento. Sua participação e contribuições são bem-vindas! Se a biblioteca que você precisa ainda não é suportada, você pode [abrir uma issue](https://github.com/jiangjianshan/msforge/issues) ou consultar o [Guia de Contribuição](#guia-de-contribuição) para adicioná-la.

## Começando Rápido
```bash
# 1. Clonar o repositório
git clone https://github.com/jiangjianshan/msforge.git
cd msforge

# 2. Verificar todos os comandos e opções disponíveis
mpt --help

# 3. Compilar e instalar todas as bibliotecas suportadas com um comando (a arquitetura padrão é x64)
mpt
```
Após a conclusão da instalação, as bibliotecas construídas estarão prontas para uso em seus projetos. Se você não quiser usar o caminho de instalação padrão, pode usar a opção `--<nome-da-biblioteca>-prefix` para especificar um caminho personalizado para cada biblioteca.

## Métodos Comuns

O `msforge` fornece uma interface de linha de comando simples e consistente. Os nomes de biblioteca listados abaixo são apenas uma pequena parte daquelas disponíveis em `ports`; todas as informações de metadados e scripts de construção fornecidos estão em `ports`.

**Instalar bibliotecas:**
```bash
# 1. Instalar bibliotecas (x64 é a arquitetura padrão)
mpt gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. Instalar bibliotecas para a arquitetura x86
mpt --arch x86 gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Desinstalar bibliotecas:**
```bash
# Desinstalar todas as bibliotecas, uma única biblioteca ou múltiplas bibliotecas
mpt --uninstall
mpt --uninstall OpenCV
mpt --uninstall gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Listar bibliotecas:**
```bash
# 1. Verificar o status de instalação de todas as bibliotecas, uma única biblioteca ou múltiplas bibliotecas
mpt --list
mpt --list OpenCV
mpt --list gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. Exibir uma renderização gráfica da árvore de dependências de todas as bibliotecas, uma única biblioteca ou múltiplas bibliotecas
mpt --dependency
mpt --dependency OpenCV
mpt --dependency gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Adicionar/Remover bibliotecas:**
```bash
# Adicionar ou remover 1 ou mais bibliotecas
mpt --add <NovoNomeDeBiblioteca>
mpt --add <NovoNomeDeBiblioteca1> <NovoNomeDeBiblioteca2>
mpt --remove <NomeDeBibliotecaExistente>
mpt --remove <NomeDeBibliotecaExistente1> <NomeDeBibliotecaExistente2>
```

**Apenas Download/Clone:**
```bash
# Fazer download e extrair os tarballs de todas as bibliotecas, uma única biblioteca ou múltiplas bibliotecas, ou clonar o código-fonte (apenas para repositórios Git) de todas as bibliotecas, uma única biblioteca ou múltiplas bibliotecas
mpt --fetch
mpt --fetch OpenCV
mpt --fetch gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Limpar cache:**
```bash
# Limpar (com confirmação) os arquivos de log, tarballs e diretórios de código-fonte de todas as bibliotecas, uma única biblioteca ou múltiplas bibliotecas
mpt --clean
mpt --clean OpenCV
mpt --clean gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```
Execute `mpt --help` para ver a lista completa de comandos e exemplos.

## Guia de Contribuição

O `msforge` já construiu com sucesso uma grande variedade de bibliotecas de código aberto e continua a se expandir. A lista completa de bibliotecas suportadas pode ser visualizada com o comando `mpt --list`. Agradecemos sinceramente qualquer contribuição.

**Você pode contribuir das seguintes maneiras:**
*   [Abrir uma issue](https://github.com/jiangjianshan/msforge/issues): Reportar um bug ou sugerir uma nova funcionalidade.
*   [Adicionar uma nova biblioteca](#adicionar-uma-nova-biblioteca): Siga o processo abaixo para adicionar uma nova biblioteca ou melhorar uma existente.

### Adicionar uma Nova Biblioteca

1.  **Gerar um template para a biblioteca:**
```bash
mpt --add <NomeDaBiblioteca>
```
O arquivo de configuração gerado `config.yaml` pode ser ajustado manualmente.

2.  **Aplicar patches (Opcional)**: Se necessário, crie arquivos `.diff` para correções específicas do Windows.
3.  **Escrever o script de construção**: No diretório `ports/<NomeDaBiblioteca>`, crie um `build.bat` ou `build.sh`, podendo consultar exemplos existentes.
4.  **Testar e enviar:**
```bash
mpt <NomeDaBiblioteca> # Construir e testar
```
Após os testes bem-sucedidos, envie um Pull Request contendo o diretório `ports/<NomeDaBiblioteca>`.

Para mais detalhes, consulte as configurações de bibliotecas existentes no diretório `ports`.

## Recursos

*   **Código Fonte & Configurações de Bibliotecas:** https://github.com/jiangjianshan/msforge
*   **Issues & Discussões:** https://github.com/jiangjianshan/msforge/issues
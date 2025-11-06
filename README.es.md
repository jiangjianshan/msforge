<div align="center">
  <h1>✨🚀 msforge 🚀✨</h1>
</div>

## Selección de idioma
[English](./README.md) | [简体中文](./README.zh-CN.md) | **Español** | [日本語](./README.ja.md)  
[한국어](./README.ko.md) | [Русский](./README.ru.md) | [Português](./README.pt-BR.md)

## Resumen del proyecto
`msforge` es un framework de construcción diseñado específicamente para entornos Windows MSVC. Su valor central reside en transformar las operaciones manuales de construcción, que son tediosas y propensas a errores, en flujos de trabajo automatizados y robustos. Esto permite a los desarrolladores concentrarse en optimizar y contribuir a las recetas de construcción, en lugar de verse inmersos en la complejidad de la cadena de herramientas subyacente.

## Características principales
- **Soporte para múltiples sistemas de construcción**: Soporte nativo para sistemas de construcción principales como CMake, Meson, Autotools, etc., detectando y configurando automáticamente el entorno de compilación correspondiente.
- **Dependencias de entorno minimizadas**: Basado en Git for Windows y algunos componentes esenciales de autotools, puede manejar proyectos Autotools sin necesidad de un entorno completo de Cygwin/MSYS2.
- **Gestión inteligente de dependencias**: Soporta resolución de dependencias complejas y ordenamiento topológico, garantizando el orden correcto de construcción y una cadena de dependencias completa.
- **Experiencia de usuario amigable**: Integra la librería [Rich](https://github.com/Textualize/rich) para proporcionar una salida de terminal colorida, mostrando en tiempo real el progreso y la información de estado de la construcción.
- **Framework de construcción confiable**: Proporciona una gran cantidad de scripts de construcción de librerías probados (en `ports`), que ya resuelven numerosos desafíos de compilación de librerías de código abierto bajo MSVC.
- **Flujo de desarrollo eficiente**: Los desarrolladores solo necesitan declarar la metainformación de la librería y centrarse en la configuración de construcción, mientras que operaciones subyacentes complejas como la descarga, el manejo de dependencias, la construcción incremental, etc., son manejadas de forma transparente por el framework.
- **Gestión completa del ciclo de vida**: Proporciona gestión de todo el flujo, desde la obtención del código fuente, la construcción e instalación, hasta la limpieza y desinstalación, soportando configuración flexible de rutas de instalación.

`msforge` está en continuo desarrollo y mejora. ¡Su participación y contribuciones son bienvenidas! Si la librería que necesita aún no está soportada, puede [enviar un issue](https://github.com/jiangjianshan/msforge/issues) o consultar la [Guía de contribución](#guía-de-contribución) para agregarla usted mismo.

## Inicio rápido
```bash
# 1. Clonar el repositorio
git clone https://github.com/jiangjianshan/msforge.git
cd msforge

# 2. Ver todos los comandos y opciones disponibles
mpt --help

# 3. Compilar e instalar todas las librerías soportadas con un solo comando (construye arquitectura x64 por defecto)
mpt
```
Una vez completada la instalación, las librerías construidas estarán listas para usar en sus proyectos. Si no desea utilizar la ruta de instalación predeterminada, puede usar la opción `--<nombre-de-librería>-prefix` para especificar una ruta de instalación personalizada para cada librería.

## Uso común

`msforge` proporciona una interfaz de línea de comandos simple y consistente. Los nombres de librería listados a continuación son solo una pequeña parte de los disponibles en `ports`; toda la metainformación y los scripts de construcción de las librerías proporcionadas se encuentran en `ports`.

**Instalar librerías:**
```bash
# 1. Instalar librerías (x64 es la arquitectura por defecto)
mpt gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. Instalar librerías para arquitectura x86
mpt --arch x86 gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Desinstalar librerías:**
```bash
# Desinstalar todas las librerías, una sola librería o múltiples librerías
mpt --uninstall
mpt --uninstall OpenCV
mpt --uninstall gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Listar librerías:**
```bash
# 1. Ver el estado de instalación de todas las librerías, una sola librería o múltiples librerías
mpt --list
mpt --list OpenCV
mpt --list gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK

# 2. Mostrar una representación gráfica del árbol de dependencias de todas las librerías, una sola librería o múltiples librerías
mpt --dependency
mpt --dependency OpenCV
mpt --dependency gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Agregar/Eliminar librerías:**
```bash
# Agregar o eliminar una o más librerías
mpt --add <nombre-de-nueva-librería>
mpt --add <nombre-de-nueva-librería1> <nombre-de-nueva-librería2>
mpt --remove <nombre-de-librería-existente>
mpt --remove <nombre-de-librería-existente1> <nombre-de-librería-existente2>
```

**Solo descargar/clonar:**
```bash
# Descargar el paquete comprimido y descomprimirlo, o clonar el código fuente (solo para repositorios Git) de todas las librerías, una sola librería o múltiples librerías
mpt --fetch
mpt --fetch OpenCV
mpt --fetch gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```

**Limpiar caché:**
```bash
# Preguntar claramente y luego eliminar archivos de registro, paquetes comprimidos y directorios de código fuente de todas las librerías, una sola librería o múltiples librerías
mpt --clean
mpt --clean OpenCV
mpt --clean gettext gmp gsl glib fftw libxml2 llvm-project mpc mpfr OpenBLAS ncurses readline VTK
```
Ejecute `mpt --help` para ver la lista completa de comandos y ejemplos.

## Guía de contribución

`msforge` ha construido con éxito una gran cantidad de librerías de código abierto de diferentes tipos y aún se está expandiendo. La lista completa de librerías soportadas se puede ver mediante el comando `mpt --list`. Agradecemos sinceramente cualquier contribución.

**Puede participar contribuyendo de las siguientes maneras:**
*   [Enviar un issue](https://github.com/jiangjianshan/msforge/issues): Reportar un error o sugerir una nueva funcionalidad.
*   [Agregar una nueva librería](#agregar-una-nueva-librería): Siga el siguiente proceso para agregar una nueva librería o mejorar una existente.

### Agregar una nueva librería

1.  **Generar una plantilla para la librería:**
```bash
mpt --add <nombre-de-librería>
```
El archivo de configuración de la librería generado `config.yaml` se puede ajustar manualmente.

2.  **Aplicar parches (opcional)**: Si se necesitan ajustes específicos para Windows, se pueden crear archivos `.diff`.
3.  **Escribir el script de construcción**: Cree un archivo `build.bat` o `build.sh` en el directorio `ports/<nombre-de-librería>`, puede consultar ejemplos existentes.
4.  **Probar y enviar:**
```bash
mpt <nombre-de-librería> # Construir y probar
```
Una vez que las pruebas sean exitosas, envíe un Pull Request que incluya el directorio `ports/<nombre-de-librería>`.

Para más detalles, consulte las configuraciones de librerías existentes en el directorio `ports`.

## Recursos

*   **Código fuente y configuraciones de librerías:** https://github.com/jiangjianshan/msforge
*   **Issues y discusiones:** https://github.com/jiangjianshan/msforge/issues
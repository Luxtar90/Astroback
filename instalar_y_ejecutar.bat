@echo off
chcp 65001 > nul
color 0A
title Instalación Automática de AstroBot

echo ===== Instalación Automática de AstroBot =====
echo.
echo Este script configurará automáticamente AstroBot en su sistema.
echo.
echo Verificando requisitos...

REM Verificar si Python está instalado
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python no está instalado. Por favor, instale Python 3.8 o superior.
    echo Puede descargarlo desde: https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

REM Verificar si Docker está instalado
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ADVERTENCIA] Docker no está instalado. Se usará el modo Python.
    echo Para usar Docker, instale Docker Desktop desde: https://www.docker.com/products/docker-desktop
    echo.
    set USE_DOCKER=0
) else (
    echo [OK] Docker está instalado.
    echo.
    set USE_DOCKER=1
)

REM Verificar si Node.js está instalado
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js no está instalado. Por favor, instale Node.js.
    echo Puede descargarlo desde: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo [OK] Todos los requisitos básicos están instalados.
echo.

REM Instalar dependencias de Python
echo Instalando dependencias de Python...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] No se pudieron instalar las dependencias de Python.
    echo.
    pause
    exit /b 1
)

REM Instalar dependencias de Node.js
echo.
echo Instalando dependencias de Node.js...
npm install
if %errorlevel% neq 0 (
    echo [ERROR] No se pudieron instalar las dependencias de Node.js.
    echo.
    pause
    exit /b 1
)

REM Verificar si existe el archivo .env
if not exist .env (
    echo.
    echo Creando archivo .env con configuración básica...
    echo OPENROUTER_API_KEY=tu_clave_api_aqui > .env
    echo WELCOME_MESSAGE=¡Hola! Soy AstroBot, tu asistente especializado en química y cálculos de laboratorio. ¿En qué puedo ayudarte hoy? >> .env
    echo DEFAULT_MODEL=openai/gpt-3.5-turbo >> .env
    echo.
    echo [IMPORTANTE] Por favor, edite el archivo .env y agregue su clave API de OpenRouter.
    echo.
)

REM Configurar el firewall (solo si se ejecuta como administrador)
net session >nul 2>&1
if %errorlevel% equ 0 (
    echo Configurando reglas de firewall...
    netsh advfirewall firewall add rule name="AstroBot Backend" dir=in action=allow protocol=TCP localport=5000
    if %errorlevel% neq 0 (
        echo [ADVERTENCIA] No se pudo configurar el firewall automáticamente.
    ) else (
        echo [OK] Firewall configurado correctamente.
    )
) else (
    echo [ADVERTENCIA] Este script no se está ejecutando como administrador.
    echo Para configurar el firewall, ejecute scripts\setup_firewall.bat como administrador.
)

echo.
echo ===== Instalación completada =====
echo.

REM Preguntar al usuario qué modo desea usar
if %USE_DOCKER% equ 1 (
    echo Seleccione el modo de ejecución:
    echo 1. Modo Docker (recomendado para producción)
    echo 2. Modo Python (recomendado para desarrollo)
    echo.
    set /p MODE="Ingrese el número de su elección (1-2): "
) else (
    set MODE=2
)

echo.
echo Iniciando AstroBot...
echo.

if "%MODE%"=="1" (
    echo Iniciando en modo Docker...
    call docker\start_docker.bat
) else (
    echo Iniciando en modo Python...
    call scripts\start_simple.bat
)

echo.
echo ===== AstroBot está en ejecución =====
echo.
echo Para iniciar AstroBot en el futuro, use uno de los siguientes scripts:
echo - start.bat                - Modo Python simple
echo - start_expo.bat           - Para dispositivos Expo
echo - start_docker.bat         - Modo Docker
echo.
echo Para más información, consulte la documentación en la carpeta docs.
echo.
pause

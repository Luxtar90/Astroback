@echo off
echo Iniciando AstroBot Backend con Docker...
echo ===== Iniciando AstroBot Backend con Docker =====

REM Cambiar al directorio raíz del proyecto
cd /d "%~dp0\.."

echo.
echo Verificando si Docker esta instalado...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker no esta instalado o no esta en el PATH.
    echo Por favor, instala Docker Desktop desde https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)

echo.
echo Deteniendo contenedores existentes...
docker-compose -f docker\docker-compose.yml down >nul 2>&1

echo.
echo Construyendo imagen Docker...
docker-compose -f docker\docker-compose.yml build

echo.
echo Iniciando contenedor Docker...
docker-compose -f docker\docker-compose.yml up -d

echo.
echo Actualizando configuracion de la aplicacion...
REM Detectar la dirección IP local
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set IP=%%a
    goto :found_ip
)
:found_ip
set IP=%IP:~1%
echo Dirección IP local detectada: %IP%

REM Verificar si existe el archivo de servicio AstroBotService.js
set "SERVICE_FILE=Astrolabx3\AstroLabCalculator\src\services\AstroBotService.js"
echo Actualizando configuración en: %CD%\%SERVICE_FILE%

if exist "%CD%\%SERVICE_FILE%" (
    REM Actualizar la configuración en el archivo de servicio
    powershell -Command "(Get-Content '%CD%\%SERVICE_FILE%') -replace 'const API_BASE_URL = .*', 'const API_BASE_URL = `"http://%IP%:5000`";' | Set-Content '%CD%\%SERVICE_FILE%'"
    echo 
    echo Configuración actualizada correctamente
) else (
    echo 
    echo No se encontró el archivo de servicio AstroBotService.js
    echo Ruta buscada: %CD%\%SERVICE_FILE%
)

echo.
echo ===== Backend iniciado correctamente con Docker =====
echo El backend esta disponible en http://localhost:5000
echo.
echo Para aplicaciones React Native:
echo 1. Asegurate de que el dispositivo/emulador este en la misma red que tu maquina
echo 2. La aplicacion se conectara automaticamente al backend
echo.
echo Para ver los logs del contenedor:
echo   docker-compose -f docker\docker-compose.yml logs -f
echo.
echo Para detener el contenedor:
echo   docker-compose -f docker\docker-compose.yml down
echo.
echo IMPORTANTE: Si usas un dispositivo fisico, ejecuta scripts\setup_firewall.bat como administrador
echo para permitir conexiones al puerto 5000.
echo.
echo Presiona cualquier tecla para continuar...
pause > nul

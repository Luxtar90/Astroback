@echo off
chcp 65001 > nul
color 0A
title Instalación Automática de Docker para AstroBot

echo ===== Instalación Automática de Docker para AstroBot =====
echo.
echo Este script verificará e instalará Docker si es necesario,
echo y configurará automáticamente el entorno para AstroBot.
echo.

REM Cambiar al directorio raíz del proyecto
cd /d "%~dp0\.."

REM Verificar si se está ejecutando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Este script debe ejecutarse como administrador.
    echo Por favor, haga clic derecho en este archivo y seleccione "Ejecutar como administrador".
    echo.
    pause
    exit /b 1
)

REM Verificar si Docker está instalado
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Docker no está instalado.
    echo.
    
    echo Verificando si Windows está en modo desarrollador...
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v "AllowDevelopmentWithoutDevLicense" | findstr "0x1" >nul
    if %errorlevel% neq 0 (
        echo [INFO] Habilitando modo desarrollador de Windows...
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v "AllowDevelopmentWithoutDevLicense" /t REG_DWORD /d 1 /f
    )
    
    echo Verificando si la característica de Hyper-V está habilitada...
    dism /online /get-featureinfo /featurename:Microsoft-Hyper-V-All | findstr "Estado : Habilitado" >nul
    if %errorlevel% neq 0 (
        echo [INFO] Habilitando Hyper-V...
        dism /online /enable-feature /featurename:Microsoft-Hyper-V /All /NoRestart
        
        echo [INFO] Habilitando Windows Subsystem for Linux...
        dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /All /NoRestart
        
        echo [INFO] Habilitando Virtual Machine Platform...
        dism /online /enable-feature /featurename:VirtualMachinePlatform /All /NoRestart
        
        echo.
        echo [IMPORTANTE] Se requiere reiniciar el sistema para completar la instalación.
        echo Después de reiniciar, ejecute este script nuevamente para continuar con la instalación.
        echo.
        choice /c SN /m "¿Desea reiniciar ahora? (S/N)"
        if %errorlevel% equ 1 (
            shutdown /r /t 10 /f
            echo El sistema se reiniciará en 10 segundos...
            timeout /t 10
            exit /b 0
        ) else (
            echo Por favor, reinicie manualmente su sistema y ejecute este script nuevamente.
            pause
            exit /b 0
        )
    )
    
    echo.
    echo [INFO] Descargando Docker Desktop...
    powershell -Command "Invoke-WebRequest -Uri 'https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe' -OutFile '%TEMP%\DockerDesktopInstaller.exe'"
    
    echo.
    echo [INFO] Instalando Docker Desktop...
    echo Esto puede tardar varios minutos. Por favor, sea paciente.
    start /wait %TEMP%\DockerDesktopInstaller.exe install --quiet
    
    echo.
    echo [INFO] Iniciando Docker Desktop...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    
    echo.
    echo [INFO] Esperando a que Docker se inicie completamente...
    echo Esto puede tardar hasta 2 minutos en la primera ejecución.
    timeout /t 120 /nobreak > nul
    
    echo.
    docker --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] La instalación de Docker parece haber fallado.
        echo Por favor, instale Docker Desktop manualmente desde:
        echo https://www.docker.com/products/docker-desktop
        echo.
        pause
        exit /b 1
    ) else (
        echo [OK] Docker se ha instalado correctamente.
    )
) else (
    echo [OK] Docker ya está instalado.
)

echo.
echo [INFO] Verificando estado de Docker...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Docker no está en ejecución. Iniciando Docker...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    
    echo [INFO] Esperando a que Docker se inicie completamente...
    echo Esto puede tardar hasta 1 minuto.
    timeout /t 60 /nobreak > nul
    
    docker info >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] No se pudo iniciar Docker.
        echo Por favor, inicie Docker Desktop manualmente y ejecute este script nuevamente.
        echo.
        pause
        exit /b 1
    )
)

echo.
echo [OK] Docker está en ejecución.
echo.

echo [INFO] Configurando AstroBot en Docker...
echo.

REM Construir y ejecutar el contenedor Docker
echo [INFO] Construyendo y ejecutando el contenedor Docker...
docker-compose -f docker\docker-compose.yml down >nul 2>&1
docker-compose -f docker\docker-compose.yml build
if %errorlevel% neq 0 (
    echo [ERROR] No se pudo construir la imagen Docker.
    echo.
    pause
    exit /b 1
)

docker-compose -f docker\docker-compose.yml up -d
if %errorlevel% neq 0 (
    echo [ERROR] No se pudo iniciar el contenedor Docker.
    echo.
    pause
    exit /b 1
)

echo.
echo [INFO] Actualizando configuración de la aplicación...
node utils\update_universal_config.js

echo.
echo [INFO] Configurando reglas de firewall...
netsh advfirewall firewall add rule name="AstroBot Backend" dir=in action=allow protocol=TCP localport=5000
if %errorlevel% neq 0 (
    echo [ADVERTENCIA] No se pudo configurar el firewall automáticamente.
) else (
    echo [OK] Firewall configurado correctamente.
)

echo.
echo ===== Instalación Completada =====
echo.
echo AstroBot está ahora en ejecución en Docker.
echo El backend está disponible en: http://localhost:5000
echo.
echo Para verificar el estado del contenedor:
echo   docker\check_docker_status.bat
echo.
echo Para detener el contenedor:
echo   docker-compose -f docker\docker-compose.yml down
echo.
echo Para iniciar el contenedor en el futuro:
echo   start_docker.bat
echo.
echo Presione cualquier tecla para salir...
pause > nul

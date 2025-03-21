@echo off
color 0A
title Configuracion de Firewall para AstroBot

echo ===== Configurando Firewall para AstroBot Backend =====
echo.

REM Verificar si se esta ejecutando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo ERROR: Este script debe ejecutarse como administrador.
    echo.
    echo Por favor, sigue estos pasos:
    echo 1. Cierra esta ventana
    echo 2. Haz clic derecho en el archivo setup_firewall_visible.bat
    echo 3. Selecciona "Ejecutar como administrador"
    echo.
    pause
    exit /b 1
)

echo Verificando si la regla ya existe...
netsh advfirewall firewall show rule name="AstroBot Backend" >nul 2>&1
if %errorlevel% equ 0 (
    echo La regla "AstroBot Backend" ya existe.
    
    echo Eliminando regla existente...
    netsh advfirewall firewall delete rule name="AstroBot Backend"
    if %errorlevel% equ 0 (
        echo Regla eliminada correctamente.
    ) else (
        color 0C
        echo Error al eliminar la regla existente.
        pause
        exit /b 1
    )
)

echo.
echo Creando regla de firewall para permitir conexiones al puerto 5000...
netsh advfirewall firewall add rule name="AstroBot Backend" dir=in action=allow protocol=TCP localport=5000

if %errorlevel% equ 0 (
    color 0A
    echo.
    echo ===== CONFIGURACION DE FIREWALL COMPLETADA =====
    echo.
    echo Se ha creado correctamente la regla "AstroBot Backend" para permitir
    echo conexiones entrantes al puerto 5000.
    echo.
    echo Ahora los dispositivos en tu red local podran conectarse al backend.
    echo.
    
    REM Verificar la regla
    echo Detalles de la regla creada:
    netsh advfirewall firewall show rule name="AstroBot Backend" | findstr /C:"Enabled" /C:"Direction" /C:"Action" /C:"LocalPort"
    
    echo.
    echo Para verificar la conexion, ejecuta:
    echo node test_expo_connection.js
    echo.
) else (
    color 0C
    echo.
    echo ERROR: No se pudo crear la regla del firewall.
    echo Por favor, verifica que tienes permisos de administrador.
    echo.
    exit /b 1
)

pause

@echo off
echo ===== Configurando Firewall para AstroBot Backend =====
echo.

REM Verificar si se esta ejecutando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Este script debe ejecutarse como administrador.
    echo Por favor, haz clic derecho en el archivo y selecciona "Ejecutar como administrador".
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
        echo Error al eliminar la regla existente.
        exit /b 1
    )
)

echo Creando regla de firewall para permitir conexiones al puerto 5000...
netsh advfirewall firewall add rule name="AstroBot Backend" dir=in action=allow protocol=TCP localport=5000

if %errorlevel% equ 0 (
    echo.
    echo ===== Configuracion de Firewall Completada =====
    echo Se ha creado correctamente la regla "AstroBot Backend" para permitir
    echo conexiones entrantes al puerto 5000.
    echo.
    echo Ahora los dispositivos en tu red local podran conectarse al backend.
    echo.
) else (
    echo.
    echo ERROR: No se pudo crear la regla del firewall.
    echo Por favor, verifica que tienes permisos de administrador.
    echo.
    exit /b 1
)

pause

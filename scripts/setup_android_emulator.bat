@echo off
echo ===== Configurando emulador Android =====
echo.

REM Verificar que adb este disponible
where adb >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo No se encontro el comando 'adb'.
    echo Asegurate de que Android SDK este instalado.
    exit /b
)

REM Configurar redireccionamiento de puertos
echo Configurando redireccionamiento del puerto 5000...
adb reverse tcp:5000 tcp:5000
if %ERRORLEVEL% EQU 0 (
    echo Redireccionamiento configurado correctamente.
) else (
    echo Error al configurar el redireccionamiento.
)

echo.

@echo off
chcp 65001 > nul
echo ===== Iniciando AstroBot Backend (Modo Simple) =====
echo.

REM Cambiar al directorio raíz del proyecto
cd /d "%~dp0\.."

REM Iniciar el backend con Python directamente
echo Iniciando el backend con Python...
start cmd /k python run.py

REM Esperar a que el backend este listo
echo Esperando a que el backend este listo...
timeout /t 5 /nobreak > nul

REM Actualizar la configuracion universal de la aplicacion
echo.
echo Actualizando configuracion de la aplicacion...
node utils\update_universal_config.js

echo.
echo ===== Backend iniciado correctamente =====
echo El backend esta disponible en http://localhost:5000
echo.
echo Para aplicaciones React Native:
echo 1. Asegurate de que el dispositivo/emulador este en la misma red que tu maquina
echo 2. La aplicacion se conectara automaticamente al backend
echo.
echo IMPORTANTE: Si usas un dispositivo fisico, ejecuta setup_firewall.bat como administrador
echo para permitir conexiones al puerto 5000.
echo.
pause

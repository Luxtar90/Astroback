@echo off
chcp 65001 > nul
echo ===== Iniciando AstroBot Backend para Expo =====
echo.

REM Cambiar al directorio raíz del proyecto
cd /d "%~dp0\.."

REM Actualizar la configuracion especifica para Expo
echo Actualizando configuracion para dispositivos Expo...
node utils\update_expo_config.js

REM Configurar el firewall (requiere permisos de administrador)
echo.
echo IMPORTANTE: Para configurar el firewall, ejecuta manualmente:
echo scripts\setup_firewall.bat como administrador
echo.

REM Probar la conexion para Expo
echo Probando conexion para dispositivos Expo...
node utils\test_expo_connection.js

REM Iniciar el backend con Python directamente
echo.
echo Iniciando el backend con Python...
python run.py

echo.
echo ===== Backend iniciado correctamente para Expo =====
echo.
echo Para probar la aplicacion en tu dispositivo Expo:
echo 1. Asegurate de que tu dispositivo este en la misma red WiFi que esta computadora
echo 2. Abre la aplicacion Expo en tu dispositivo
echo 3. Si tienes problemas de conexion, reinicia la aplicacion Expo
echo.

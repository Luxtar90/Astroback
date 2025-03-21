@echo off
chcp 65001 > nul
color 0A
title AstroBot Backend para Expo (WSL)

echo ===== Iniciando AstroBot Backend para Expo (WSL) =====
echo.

REM Detener el backend actual si esta en ejecucion
echo Deteniendo procesos de Python...
taskkill /f /im python.exe >nul 2>&1

REM Actualizar la configuracion para usar la IP de WSL
echo.
echo Actualizando configuracion para usar la IP de WSL...
node update_wsl_config.js

REM Iniciar el backend
echo.
echo Iniciando el backend...
start cmd /k python run.py

REM Esperar a que el backend este listo
echo Esperando a que el backend este listo...
timeout /t 5 /nobreak > nul

REM Probar la conexion
echo.
echo Probando la conexion...
node test_wsl_connection.js

echo.
echo ===== Instrucciones para Expo =====
echo 1. Reinicia completamente la aplicacion Expo en tu dispositivo
echo 2. Asegurate de que tu dispositivo este en la misma red WiFi que tu PC
echo 3. Si sigues teniendo problemas, ejecuta setup_firewall.bat como administrador
echo.
echo IMPORTANTE: La IP de WSL (172.18.112.1) puede no ser accesible desde dispositivos externos.
echo Si no puedes conectarte, prueba con la IP de tu tarjeta de red fisica.
echo.
pause

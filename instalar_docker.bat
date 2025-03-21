@echo off
echo Iniciando instalación automática de Docker para AstroBot...
echo.
echo IMPORTANTE: Este script debe ejecutarse como administrador.
echo Si no lo has hecho, cierra esta ventana y ejecuta como administrador.
echo.
pause
cd /d "%~dp0"
call docker\docker_auto_install.bat

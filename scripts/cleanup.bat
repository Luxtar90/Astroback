@echo off
echo ===== Limpiando archivos temporales y no utilizados =====

echo.
echo Eliminando archivos de cache de Python...
if exist __pycache__ rmdir /s /q __pycache__
if exist app\__pycache__ rmdir /s /q app\__pycache__

echo.
echo Eliminando archivos temporales...
del /q *.pyc 2>nul
del /q *.log 2>nul
del /q *.tmp 2>nul

echo.
echo Limpieza completada.
echo.
echo Proyecto optimizado y listo para usar.
echo.
echo Para iniciar el backend, ejecuta:
echo   start_simple.bat    - Para uso general
echo   start_expo.bat      - Para dispositivos Expo
echo   start_expo_wsl.bat  - Para dispositivos a través de WSL
echo.
echo Presiona cualquier tecla para salir...
pause > nul

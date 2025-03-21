@echo off
echo ===== Verificando estado del contenedor Docker de AstroBot =====

REM Cambiar al directorio raíz del proyecto
cd /d "%~dp0\.."

echo.
echo Comprobando si Docker esta en ejecucion...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker no esta en ejecucion o no esta instalado.
    echo Por favor, inicia Docker Desktop y vuelve a intentarlo.
    echo.
    pause
    exit /b 1
)

echo.
echo Verificando estado del contenedor...
docker ps --filter "name=astrobot-backend" --format "{{.Status}}" | findstr "Up" >nul
if %errorlevel% neq 0 (
    echo El contenedor no esta en ejecucion.
    echo.
    echo Para iniciar el contenedor, ejecuta:
    echo   start_docker.bat
    echo.
    pause
    exit /b 1
)

echo.
echo Contenedor en ejecucion correctamente.
echo.

echo Verificando estado de salud del contenedor...
docker inspect --format "{{.State.Health.Status}}" astrobot-backend 2>nul | findstr "healthy" >nul
if %errorlevel% neq 0 (
    echo ADVERTENCIA: El contenedor podria no estar funcionando correctamente.
    echo Verificando logs para diagnosticar el problema...
    echo.
    docker logs --tail 20 astrobot-backend
    echo.
    echo Puedes ver mas logs con:
    echo   docker logs astrobot-backend
    echo.
    pause
    exit /b 1
)

echo.
echo El contenedor esta funcionando correctamente.
echo.

echo Verificando conectividad...
curl -s http://localhost:5000/status >nul
if %errorlevel% neq 0 (
    echo ADVERTENCIA: No se puede conectar al backend en http://localhost:5000/status
    echo Esto podria indicar un problema con la aplicacion dentro del contenedor.
    echo.
    echo Verificando logs para diagnosticar el problema...
    docker logs --tail 20 astrobot-backend
    echo.
    pause
    exit /b 1
)

echo.
echo ===== Todo esta funcionando correctamente =====
echo.
echo El backend de AstroBot esta en ejecucion y responde correctamente.
echo URL: http://localhost:5000
echo.
echo Informacion del contenedor:
docker ps --filter "name=astrobot-backend" --format "ID: {{.ID}}\nNombre: {{.Names}}\nEstado: {{.Status}}\nPuertos: {{.Ports}}"
echo.
echo Para detener el contenedor:
echo   docker-compose -f docker\docker-compose.yml down
echo.
echo Para ver los logs:
echo   docker logs astrobot-backend
echo.
echo Presiona cualquier tecla para salir...
pause > nul

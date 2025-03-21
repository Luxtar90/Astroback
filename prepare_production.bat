@echo off
echo ===== Preparando AstroBot Backend para Produccion =====
cd /d "%~dp0"

REM Verificar si Docker está instalado
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker no esta instalado o no esta en el PATH.
    echo Por favor, instala Docker Desktop desde https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)

REM Detener contenedores existentes
echo.
echo Deteniendo contenedores existentes...
docker-compose -f docker\docker-compose.yml down

REM Crear directorio de logs si no existe
if not exist logs (
    echo Creando directorio de logs...
    mkdir logs
)

REM Verificar si existe el archivo .env
if not exist .env (
    echo No se encontro el archivo .env
    if exist .env.example (
        echo Copiando .env.example a .env
        copy .env.example .env
        echo Por favor, edita el archivo .env con tus configuraciones antes de continuar.
        echo Especialmente, asegurate de configurar OPENROUTER_API_KEY.
        notepad .env
    ) else (
        echo No se encontro el archivo .env.example
        echo Creando un archivo .env basico...
        echo OPENROUTER_API_KEY=tu-clave-api> .env
        echo DEBUG=False>> .env
        echo LOG_LEVEL=INFO>> .env
        echo Por favor, edita el archivo .env con tus configuraciones.
        notepad .env
    )
)

REM Construir la imagen Docker
echo.
echo Construyendo imagen Docker para produccion...
docker-compose -f docker\docker-compose.yml build

echo.
echo ===== Preparacion completada =====
echo.
echo Para iniciar el backend en modo produccion, ejecuta:
echo   docker-compose -f docker\docker-compose.yml up -d
echo.
echo Para ver los logs:
echo   docker-compose -f docker\docker-compose.yml logs -f
echo.
echo Para detener el backend:
echo   docker-compose -f docker\docker-compose.yml down
echo.
echo Para desplegar en un servidor de produccion, consulta:
echo   docs\DESPLIEGUE_PRODUCCION.md
echo.

REM Preguntar si desea iniciar el backend ahora
set /p START_NOW=Deseas iniciar el backend ahora? (S/N): 
if /i "%START_NOW%"=="S" (
    echo.
    echo Iniciando el backend en modo produccion...
    docker-compose -f docker\docker-compose.yml up -d
    
    REM Esperar a que el servicio esté disponible
    echo Esperando a que el servicio este disponible...
    timeout /t 5 /nobreak > nul
    
    REM Verificar si el servicio está funcionando
    curl -s http://localhost:5000/status > nul
    if %errorlevel% equ 0 (
        echo.
        echo El backend esta funcionando correctamente.
        echo Esta disponible en: http://localhost:5000
        
        REM Obtener la IP local
        for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
            set IP=%%a
            goto :found_ip
        )
        :found_ip
        set IP=%IP:~1%
        echo Para acceder desde otros dispositivos en la red local: http://%IP%:5000
    ) else (
        echo.
        echo ERROR: El servicio no esta respondiendo.
        echo Verifica los logs con: docker-compose -f docker\docker-compose.yml logs
    )
)

echo.
echo Presiona cualquier tecla para continuar...
pause > nul

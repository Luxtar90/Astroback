#!/usr/bin/env bash
# render-build.sh - Script de construcción para Render

# Salir inmediatamente si algún comando falla
set -e

echo " Iniciando script de construcción para Render..."

# Instalar dependencias
echo " Instalando dependencias desde requirements.txt..."
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn gevent

# Crear directorio de logs si no existe
mkdir -p logs

# Asegurar que los archivos tienen permisos de ejecución
chmod +x app.py
chmod +x wsgi.py
chmod +x run.py

# Verificar si gunicorn_config.py existe
echo "Verificando si gunicorn_config.py existe..."
if [ -f "gunicorn_config.py" ]; then
    echo "gunicorn_config.py EXISTE"
    chmod +x gunicorn_config.py
    echo "Contenido de gunicorn_config.py:"
    cat gunicorn_config.py
else
    echo "ERROR: gunicorn_config.py NO EXISTE"
    echo "Creando gunicorn_config.py..."
    cat > gunicorn_config.py << 'EOL'
#!/usr/bin/env python
# gunicorn_config.py - Configuración optimizada para Gunicorn en producción

import os

# Configuración básica
bind = "0.0.0.0:10000"
workers = 4
worker_class = "gevent"
worker_connections = 1000
timeout = 30
keepalive = 2

# Configuración de logging
accesslog = "-"
errorlog = "-"
loglevel = os.getenv("LOG_LEVEL", "info").lower()

# Configuración de seguridad
limit_request_line = 4096
limit_request_fields = 100
limit_request_field_size = 8190

# Configuración de rendimiento
graceful_timeout = 30
max_requests = 1000
max_requests_jitter = 50
EOL
    chmod +x gunicorn_config.py
    echo "gunicorn_config.py creado correctamente"
fi

# Mostrar información sobre la estructura del proyecto
echo "Estructura del proyecto:"
find . -type f -name "*.py" | sort

# Mostrar información sobre el archivo app.py
echo "Contenido de app.py:"
cat app.py

# Mostrar información sobre el archivo wsgi.py
echo "Contenido de wsgi.py:"
cat wsgi.py

# Mostrar información sobre el archivo run.py
echo "Contenido de run.py:"
cat run.py

# Verificar que la aplicación se puede importar correctamente desde app.py
echo "Verificando importación de la aplicación desde app.py..."
python -c "import sys; sys.path.insert(0, '.'); from app import create_app; app = create_app(); print('Importación desde app.py exitosa!')"

# Verificar que la aplicación se puede importar correctamente desde wsgi.py
echo "Verificando importación de la aplicación desde wsgi.py..."
python -c "import sys; sys.path.insert(0, '.'); import wsgi; print('Módulo wsgi importado correctamente'); print('wsgi tiene los siguientes atributos:', dir(wsgi))"

# Verificar que la aplicación se puede importar correctamente desde run.py
echo "Verificando importación de la aplicación desde run.py..."
python -c "import sys; sys.path.insert(0, '.'); import run; print('Módulo run importado correctamente'); print('run tiene los siguientes atributos:', dir(run))"

# Verificar que gunicorn puede importar la aplicación
echo "Verificando que gunicorn puede importar la aplicación..."
python -c "import sys; sys.path.insert(0, '.'); import run; print('Módulo run importado correctamente'); print('run.app existe:', hasattr(run, 'app'))"

# Verificar la configuración de Gunicorn
echo "Verificando configuración de Gunicorn..."
python -c "import sys; sys.path.insert(0, '.'); import gunicorn_config; print('Configuración de Gunicorn cargada correctamente')"

# Mostrar versiones de las dependencias principales
echo "Versiones de dependencias:"
pip freeze | grep -E 'Flask|gunicorn|gevent|openai|python-dotenv'

echo "Construcción completada con éxito"

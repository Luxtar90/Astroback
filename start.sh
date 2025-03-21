#!/usr/bin/env bash
# start.sh - Script alternativo para iniciar la aplicación

# Verificar si gunicorn_config.py existe
if [ -f "gunicorn_config.py" ]; then
    echo "Usando gunicorn_config.py"
    # Usamos el módulo gevent_patch para asegurar que el monkey patching se aplique temprano
    exec gunicorn --preload -c gunicorn_config.py run:app
else
    echo "gunicorn_config.py no existe, usando parámetros directamente"
    # Usamos el módulo gevent_patch para asegurar que el monkey patching se aplique temprano
    exec gunicorn --preload run:app --bind=0.0.0.0:10000 --workers=4 --worker-class=gevent --timeout=30
fi

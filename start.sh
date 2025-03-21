#!/usr/bin/env bash
# start.sh - Script alternativo para iniciar la aplicación

# Verificar si gunicorn_config.py existe
if [ -f "gunicorn_config.py" ]; then
    echo "Usando gunicorn_config.py"
    exec gunicorn run:app -c gunicorn_config.py
else
    echo "gunicorn_config.py no existe, usando parámetros directamente"
    exec gunicorn run:app --bind=0.0.0.0:10000 --workers=4 --worker-class=gevent --timeout=30
fi

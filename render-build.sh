#!/usr/bin/env bash
# Script de construcción para Render

# Salir en caso de error
set -o errexit

# Instalar dependencias
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn gevent

# Crear directorio de logs si no existe
mkdir -p logs

# Asegurar que los archivos tienen permisos de ejecución
chmod +x app.py
chmod +x wsgi.py
chmod +x gunicorn_config.py

# Mostrar información sobre la estructura del proyecto
echo "Estructura del proyecto:"
find . -type f -name "*.py" | sort

# Mostrar información sobre el archivo app.py
echo "Contenido de app.py:"
cat app.py

# Verificar que la aplicación se puede importar correctamente
echo "Verificando importación de la aplicación..."
python -c "import sys; sys.path.insert(0, '.'); from app import create_app; application = create_app(); print('Importación exitosa!')"

# Verificar que gunicorn puede importar la aplicación
echo "Verificando que gunicorn puede importar la aplicación..."
python -c "import sys; sys.path.insert(0, '.'); import app; print('Módulo app importado correctamente'); print('app tiene los siguientes atributos:', dir(app))"

# Verificar la configuración de Gunicorn
echo "Verificando configuración de Gunicorn..."
python -c "import gunicorn_config; print('Configuración de Gunicorn cargada correctamente')"

# Mostrar versiones de las dependencias principales
echo "Versiones de dependencias:"
pip freeze | grep -E 'Flask|gunicorn|gevent|openai|python-dotenv'

echo "Construcción completada con éxito"

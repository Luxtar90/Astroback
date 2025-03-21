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

# Mostrar versiones de las dependencias principales
echo "Versiones de dependencias:"
pip freeze | grep -E 'Flask|gunicorn|gevent|openai|python-dotenv'

echo "Construcción completada con éxito"

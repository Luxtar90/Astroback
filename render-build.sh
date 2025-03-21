#!/usr/bin/env bash
# Script de construcción para Render

# Salir en caso de error
set -o errexit

# Instalar dependencias
pip install --upgrade pip
pip install -r requirements.txt

# Crear directorio de logs si no existe
mkdir -p logs

# Mostrar información sobre la estructura del proyecto
echo "Estructura del proyecto:"
find . -type f -name "*.py" | sort

# Mostrar información sobre el archivo app.py
echo "Contenido de app.py:"
cat app.py

# Verificar que la aplicación se puede importar
echo "Verificando importación de la aplicación..."
python -c "from app import create_app; app = create_app(); print('Importación exitosa!')"

echo "Construcción completada con éxito"

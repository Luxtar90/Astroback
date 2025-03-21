#!/usr/bin/env python
# wsgi.py - Punto de entrada alternativo para servidores WSGI
from dotenv import load_dotenv
import os
import sys

# Asegurarse de que el directorio actual está en el path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Cargar variables de entorno
load_dotenv()

# Importar la función create_app desde el paquete app
from app import create_app

# Crear la instancia de la aplicación
app = create_app()

if __name__ == '__main__':
    # Configurar host='0.0.0.0' permite que el servidor sea accesible 
    # desde cualquier dispositivo en la red, no solo desde localhost
    app.run(host='0.0.0.0', port=5000)

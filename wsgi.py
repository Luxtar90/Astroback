#!/usr/bin/env python
# wsgi.py - Punto de entrada para servidores WSGI como Gunicorn
"""
Este módulo es el punto de entrada para servidores WSGI como Gunicorn.
Importa la aplicación Flask desde el paquete app y la expone como 'app'.
"""
import logging
import os
import sys

# Configurar logging
logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO").upper(),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Asegurarse de que el directorio actual está en el path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

logger.info("Iniciando aplicación AstroBot desde wsgi.py")
logger.info(f"Directorio de trabajo: {os.getcwd()}")
logger.info(f"Python path: {sys.path}")

try:
    # Importar la función create_app desde el paquete app
    from app import create_app
    
    # Crear la instancia de la aplicación
    app = create_app()
    logger.info("Aplicación Flask creada correctamente en wsgi.py")
except Exception as e:
    logger.error(f"Error al crear la aplicación en wsgi.py: {str(e)}")
    raise

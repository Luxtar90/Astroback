#!/usr/bin/env python
# app.py - Punto de entrada principal para la aplicación AstroBot
"""
Este módulo es el punto de entrada principal para la aplicación AstroBot.
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

# Registrar información de inicio
logger.info("Iniciando aplicación AstroBot")
logger.info(f"Directorio de trabajo: {os.getcwd()}")
logger.info(f"Python path: {sys.path}")

try:
    # Importar la función create_app desde el paquete app
    from app import create_app
    
    # Crear la instancia de la aplicación
    app = create_app()
    
    logger.info("Aplicación Flask creada correctamente")
except Exception as e:
    logger.error(f"Error al crear la aplicación: {str(e)}")
    raise

if __name__ == '__main__':
    # Configurar host='0.0.0.0' permite que el servidor sea accesible 
    # desde cualquier dispositivo en la red, no solo desde localhost
    port = int(os.getenv("PORT", 5000))
    logger.info(f"Iniciando servidor en el puerto {port}")
    app.run(host='0.0.0.0', port=port)

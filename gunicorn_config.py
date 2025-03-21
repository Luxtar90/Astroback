#!/usr/bin/env python
# gunicorn_config.py - Configuración optimizada para Gunicorn en producción

# Aplicar monkey patching de gevent antes que cualquier otra cosa
from gevent import monkey
monkey.patch_all()

import multiprocessing
import os

# Configuración básica
bind = "0.0.0.0:10000"  # Render asigna automáticamente el puerto, pero podemos especificar uno por defecto
workers = 4  # Número fijo de workers para evitar problemas
worker_class = "gevent"  # Usar gevent para mejor rendimiento con operaciones I/O
worker_connections = 1000
timeout = 30
keepalive = 2

# Configuración de logging
accesslog = "-"  # Enviar a stdout para que Render pueda capturarlo
errorlog = "-"   # Enviar a stderr para que Render pueda capturarlo
loglevel = os.getenv("LOG_LEVEL", "info").lower()

# Configuración de seguridad
limit_request_line = 4096
limit_request_fields = 100
limit_request_field_size = 8190

# Configuración de rendimiento
graceful_timeout = 30
max_requests = 1000
max_requests_jitter = 50

# Configuración preload_app para aplicar monkey patching antes de cargar la aplicación
preload_app = True

def on_starting(server):
    """Función que se ejecuta al iniciar el servidor"""
    print("Servidor Gunicorn iniciando con configuración optimizada")

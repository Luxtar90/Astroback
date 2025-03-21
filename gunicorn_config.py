#!/usr/bin/env python
# gunicorn_config.py - Configuración optimizada para Gunicorn en producción

import multiprocessing
import os

# Configuración básica
bind = "0.0.0.0:10000"  # Render asigna automáticamente el puerto, pero podemos especificar uno por defecto
workers = multiprocessing.cpu_count() * 2 + 1  # Fórmula recomendada para workers
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

# Hooks - Comentados para evitar errores
# def on_starting(server):
#     """Ejecutado cuando el servidor está iniciando."""
#     pass

# def on_reload(server):
#     """Ejecutado cuando el servidor se recarga."""
#     pass

# def post_fork(server, worker):
#     """Ejecutado después de crear un worker."""
#     pass

# def worker_exit(server, worker):
#     """Ejecutado cuando un worker sale."""
#     pass

# def worker_abort(worker):
#     """Ejecutado cuando un worker es abortado."""
#     pass

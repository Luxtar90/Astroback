# app/__init__.py
from flask import Flask
from flask_cors import CORS
from .config import Config
import logging
import os
from logging.handlers import RotatingFileHandler

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    
    # Configuración de logging
    configure_logging(app)
    
    # Habilita CORS para permitir peticiones desde cualquier origen
    CORS(app, resources={r"/*": {"origins": "*"}})
    
    # Registra las rutas definidas en routes.py
    from .routes import bp as routes_bp
    app.register_blueprint(routes_bp)
    
    app.logger.info('AstroBot backend iniciado')
    
    return app

def configure_logging(app):
    # Asegurarse de que exista el directorio de logs
    logs_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'logs')
    if not os.path.exists(logs_dir):
        os.makedirs(logs_dir)
    
    # Configurar el nivel de log según la configuración
    log_level = getattr(logging, app.config.get('LOG_LEVEL', 'INFO'))
    
    # Configurar el handler para archivo
    file_handler = RotatingFileHandler(
        os.path.join(logs_dir, 'astrobot.log'),
        maxBytes=10485760,  # 10MB
        backupCount=10
    )
    file_handler.setFormatter(logging.Formatter(
        '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
    ))
    file_handler.setLevel(log_level)
    
    # Configurar el handler para consola
    console_handler = logging.StreamHandler()
    console_handler.setLevel(log_level)
    console_handler.setFormatter(logging.Formatter('%(levelname)s: %(message)s'))
    
    # Aplicar la configuración al logger de la aplicación
    app.logger.addHandler(file_handler)
    app.logger.addHandler(console_handler)
    app.logger.setLevel(log_level)

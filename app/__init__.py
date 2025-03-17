# app/__init__.py
from flask import Flask
from flask_cors import CORS
from .config import Config

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    
    # Habilita CORS para permitir peticiones desde otros orígenes
    CORS(app)
    
    # Registra las rutas definidas en routes.py
    from .routes import bp as routes_bp
    app.register_blueprint(routes_bp)
    
    return app

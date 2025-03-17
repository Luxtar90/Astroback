# app/config.py
import os

class Config:
    # Se obtiene la API key desde una variable de entorno
    OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")
    # URL base para OpenRouter (puedes modificarla si es necesario)
    OPENROUTER_API_BASE = os.getenv("OPENROUTER_API_BASE", "https://openrouter.ai/api/v1")
    # Modelo predeterminado a utilizar (puedes cambiarlo según tus preferencias)
    DEFAULT_MODEL = os.getenv("DEFAULT_MODEL", "deepseek/deepseek-chat:free")
    # Lista de modelos disponibles para usar
    AVAILABLE_MODELS = [
        "open-r1/olympiccoder-7b:free",
        "deepseek/deepseek-r1-zero-base",
        "mistralai/mistral-7b-instruct:free",
        "google/gemma-7b-it:free"
    ]
    # Mensaje de bienvenida predeterminado (puede ser personalizado)
    WELCOME_MESSAGE = os.getenv("WELCOME_MESSAGE", 
        "¡Hola! Soy AstroBot, tu asistente especializado en química y cálculos de laboratorio. ¿En qué puedo ayudarte hoy?")
    # Habilitar saludo automático al iniciar
    AUTO_WELCOME = os.getenv("AUTO_WELCOME", "True").lower() in ('true', '1', 't')
    DEBUG = True  # Activa el modo debug para desarrollo (desactívalo en producción)

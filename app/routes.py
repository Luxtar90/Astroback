# app/routes.py
from flask import Blueprint, request, jsonify, current_app
from .ai import process_message
import logging

# Configurar logging
logger = logging.getLogger(__name__)

bp = Blueprint('main', __name__)

@bp.route('/welcome', methods=['GET'])
def welcome():
    """Endpoint para obtener un saludo automático del bot"""
    try:
        # Obtener el mensaje de bienvenida desde la configuración
        welcome_message = current_app.config.get("WELCOME_MESSAGE", 
            "¡Hola! Soy AstroBot, tu asistente especializado en química y cálculos de laboratorio. ¿En qué puedo ayudarte hoy?")
        
        # Obtener el modelo predeterminado
        default_model = current_app.config.get("DEFAULT_MODEL", "")
        
        return jsonify({
            'status': 'success',
            'response': welcome_message,
            'model': default_model,
            'isWelcome': True
        }), 200
    except Exception as e:
        logger.error(f"Error al generar saludo de bienvenida: {str(e)}", exc_info=True)
        return jsonify({
            'status': 'error',
            'message': f'Error al generar saludo de bienvenida: {str(e)}'
        }), 500

@bp.route('/status', methods=['GET'])
def status():
    """Endpoint para verificar el estado del servidor"""
    try:
        return jsonify({
            "status": "ok",
            "message": "AstroBot backend is running",
            "version": current_app.config.get("VERSION", "1.0.0")
        }), 200
    except Exception as e:
        logger.error(f"Error en el endpoint de status: {str(e)}")
        return jsonify({
            "status": "error",
            "message": "Error interno del servidor"
        }), 500

@bp.route('/healthcheck', methods=['GET'])
def healthcheck():
    """Endpoint para verificar el estado del servidor"""
    try:
        # Verificar si tenemos la clave API configurada
        api_key = current_app.config.get("OPENROUTER_API_KEY")
        if not api_key:
            return jsonify({
                'status': 'warning',
                'message': 'El servidor está en funcionamiento, pero falta la clave API de OpenRouter'
            }), 200
        
        return jsonify({
            'status': 'ok',
            'message': 'El servidor está en funcionamiento correctamente',
            'version': '1.0.0'
        }), 200
    except Exception as e:
        logger.error(f"Error al verificar el estado: {str(e)}", exc_info=True)
        return jsonify({
            'status': 'error',
            'message': f'Error al verificar el estado: {str(e)}'
        }), 500

@bp.route('/models', methods=['GET'])
def get_models():
    """Endpoint para obtener la lista de modelos disponibles"""
    try:
        # Obtener la lista de modelos disponibles desde la configuración
        available_models = current_app.config.get("AVAILABLE_MODELS", [])
        default_model = current_app.config.get("DEFAULT_MODEL", "")
        
        return jsonify({
            'status': 'success',
            'models': available_models,
            'default': default_model
        }), 200
    except Exception as e:
        logger.error(f"Error al obtener los modelos: {str(e)}", exc_info=True)
        return jsonify({
            'status': 'error',
            'message': f'Error al obtener los modelos: {str(e)}'
        }), 500

@bp.route('/chat', methods=['POST'])
def chat():
    """Endpoint para procesar mensajes de chat"""
    try:
        # Verificar que la solicitud contiene JSON
        if not request.is_json:
            return jsonify({
                'status': 'error',
                'message': 'La solicitud debe contener JSON'
            }), 400
        
        data = request.get_json()
        
        # Verificar que el mensaje está presente
        user_message = data.get('message', '')
        if not user_message:
            return jsonify({
                'status': 'error',
                'message': 'El mensaje no puede estar vacío'
            }), 400
        
        # Obtener el ID de sesión y el modelo si están presentes
        session_id = data.get('sessionId')
        model_name = data.get('model')
        
        # Procesar el mensaje
        logger.info(f"Recibida solicitud de chat. Session ID: {session_id}, Modelo: {model_name}")
        response_data = process_message(user_message, model_name)
        
        return jsonify({
            'status': 'success',
            'response': response_data['response'],
            'model': response_data['model'],
            'sessionId': session_id
        }), 200
    
    except Exception as e:
        logger.error(f"Error en el endpoint de chat: {str(e)}", exc_info=True)
        return jsonify({
            'status': 'error',
            'message': f'Error en el servidor: {str(e)}'
        }), 500

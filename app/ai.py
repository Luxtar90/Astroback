import openai
from flask import current_app
import logging
import re

# Configurar logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def clean_response(text):
    """
    Limpia la respuesta del modelo eliminando formatos LaTeX y JSON no deseados.
    
    Args:
        text (str): Texto de respuesta del modelo
        
    Returns:
        str: Texto limpio
    """
    # Eliminar formato LaTeX \boxed{{...}}
    text = re.sub(r'\\boxed\{\{', '', text)
    text = re.sub(r'\}\}$', '', text)
    
    # Intentar extraer contenido de JSON si está en ese formato
    json_match = re.search(r'"answer":\s*"([^"]+)"', text)
    if json_match:
        text = json_match.group(1)
        # Eliminar escapes de comillas
        text = text.replace('\\"', '"')
    
    # Eliminar otros posibles formatos LaTeX
    text = re.sub(r'\\[a-zA-Z]+\{([^}]+)\}', r'\1', text)
    
    return text.strip()

def process_message(message, model_name=None):
    """
    Procesa un mensaje del usuario y obtiene una respuesta del modelo de IA.
    
    Args:
        message (str): El mensaje del usuario
        model_name (str, optional): Nombre del modelo a utilizar. Si es None, se usa el modelo predeterminado.
        
    Returns:
        dict: Diccionario con la respuesta y el nombre del modelo utilizado
    """
    try:
        # Obtener configuración desde la aplicación
        openai.api_key = current_app.config.get("OPENROUTER_API_KEY")
        openai.api_base = current_app.config.get("OPENROUTER_API_BASE")
        openai.api_type = "open_ai"  # Si OpenRouter lo requiere
        
        # Usar el modelo especificado o el predeterminado
        if not model_name:
            model_name = current_app.config.get("DEFAULT_MODEL")
        
        logger.info(f"Procesando mensaje con modelo {model_name}: {message[:50]}...")
        
        # Prompt del sistema específico para AstroLab
        system_prompt = """Eres AstroBot, un asistente especializado en química y cálculos de laboratorio para la aplicación AstroLab Calculator. 
        Tienes conocimientos sobre:
        1. Cálculos de masa molar de compuestos químicos
        2. Diluciones y concentraciones de soluciones
        3. Cálculos de pureza de reactivos
        4. Estequiometría y balanceo de ecuaciones químicas
        5. Propiedades físico-químicas de elementos y compuestos
        
        Proporciona respuestas detalladas, precisas y educativas. Incluye fórmulas relevantes y ejemplos cuando sea apropiado.
        Si no conoces la respuesta a una pregunta específica, indícalo claramente en lugar de inventar información.
        
        IMPORTANTE: Responde directamente en texto plano. No uses formatos LaTeX ni estructuras JSON.
        """
        
        response = openai.ChatCompletion.create(
            model=model_name,  # Usar el modelo especificado o el predeterminado
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": message}
            ],
            max_tokens=500,  # Aumentado para permitir respuestas más detalladas
            temperature=0.7,
            headers={
                "HTTP-Referer": "https://astrolab-calculator.com",  # Reemplaza con tu dominio real si lo tienes
                "X-Title": "AstroLab Calculator"
            }
        )
        
        # El contenido de la respuesta se encuentra en 'message.content'
        raw_result = response.choices[0].message.content.strip()
        logger.info(f"Respuesta generada (sin procesar): {raw_result[:50]}...")
        
        # Limpiar la respuesta
        cleaned_result = clean_response(raw_result)
        logger.info(f"Respuesta limpia: {cleaned_result[:50]}...")
        
        # Devolver la respuesta y el nombre del modelo utilizado
        return {
            "response": cleaned_result,
            "model": model_name
        }
    
    except Exception as e:
        logger.error(f"Error al comunicarse con la IA: {str(e)}", exc_info=True)
        return {
            "response": f"Error al comunicarse con la IA: {str(e)}",
            "model": model_name or "desconocido",
            "error": True
        }

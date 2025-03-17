# Integración con Backend Flask para AstroBot

Este documento describe cómo integrar el frontend de AstroBot con el backend Flask que utiliza OpenRouter para acceder a modelos de lenguaje como GPT-3.5-turbo.

## Estructura del Backend

El backend está construido con Flask y tiene la siguiente estructura:

```python
backend/
├── app/
│   ├── __init__.py      # Inicialización de la aplicación Flask
│   ├── ai.py            # Funciones para interactuar con OpenRouter
│   ├── config.py        # Configuración de la aplicación
│   └── routes.py        # Definición de rutas y endpoints
├── .env                 # Variables de entorno (no incluir en control de versiones)
└── run.py               # Script para ejecutar la aplicación
```

## Configuración del Backend

### Requisitos

Para ejecutar el backend, necesitas:

- Python 3.8 o superior
- Las dependencias listadas en `requirements.txt`:
  - Flask
  - flask-cors
  - openai==0.28.0
  - python-dotenv

### Variables de Entorno

El backend requiere las siguientes variables de entorno:

```bash
OPENROUTER_API_KEY=tu_clave_api_de_openrouter
OPENROUTER_API_BASE=https://openrouter.ai/api/v1
```

Estas variables deben definirse en un archivo `.env` en la raíz del proyecto backend.

### Configuración para Dispositivos Móviles

Para permitir que dispositivos móviles se conecten al backend, es necesario configurar Flask para que escuche en todas las interfaces de red:

1. Modifica el archivo `run.py` para que contenga:

```python
# run.py
from app import create_app
from dotenv import load_dotenv

# Carga las variables de entorno definidas en el archivo .env
load_dotenv()

app = create_app()

if __name__ == '__main__':
    # Configurar host='0.0.0.0' permite que el servidor sea accesible 
    # desde cualquier dispositivo en la red, no solo desde localhost
    app.run(host='0.0.0.0', port=5000, debug=True)
```

2. En el frontend, actualiza la URL del backend para usar la dirección IP de tu computadora en la red local:

```javascript
// En AstroBotService.js
const API_BASE_URL = 'http://192.168.100.129:5000'; // Reemplaza con tu IP local
```

Puedes encontrar tu dirección IP local con el comando `ipconfig` en Windows o `ifconfig` en Mac/Linux.

## Pasos para la Integración

1. Clonar el repositorio del backend desde GitHub:

```bash
git clone https://github.com/user/astrobot-backend.git
cd astrobot-backend
```

2. Instalar las dependencias:

```bash
pip install -r requirements.txt
```

## Endpoints API

### POST /chat

Este endpoint procesa los mensajes enviados por el usuario y devuelve respuestas generadas por el modelo de IA.

**Solicitud:**

```json
{
  "message": "¿Qué es la masa molar?"
}
```

**Respuesta:**

```json
{
  "response": "La masa molar es la masa de un mol de una sustancia, expresada en gramos/mol. Para calcular la masa molar de un compuesto, suma las masas atómicas de todos los átomos en la fórmula molecular."
}
```

## Integración Frontend-Backend

### Configuración del Frontend

En el archivo `AstroBotService.js`, asegúrate de que la URL base apunte a tu servidor Flask:

```javascript
const API_BASE_URL = 'http://127.0.0.1:5000'; // Cambia esto a la URL de tu servidor en producción
```

### Flujo de Comunicación

1. **Verificación de Conexión:**

   - El frontend verifica la conexión con el backend enviando un mensaje "ping" al endpoint `/chat`.
   - Si la conexión es exitosa, se habilita la funcionalidad completa del chat.
   - Si la conexión falla, se activa el modo de simulación.

2. **Envío de Mensajes:**

   - El usuario escribe un mensaje en la interfaz de chat.
   - El frontend envía el mensaje al backend a través del endpoint `/chat`.
   - El backend procesa el mensaje utilizando OpenRouter y devuelve la respuesta.
   - El frontend muestra la respuesta en la interfaz de chat.

3. **Manejo de Errores:**

   - Si el backend no responde dentro del tiempo límite, se muestra un mensaje de error.
   - Si el backend devuelve un error, se muestra un mensaje apropiado.
   - En ambos casos, se activa el modo de simulación para permitir una experiencia de usuario continua.

## Modo de Simulación

Cuando el backend no está disponible, el frontend activa automáticamente un modo de simulación que:

- Genera respuestas predefinidas basadas en patrones simples
- Muestra un indicador claro de que se está en modo simulación
- Permite al usuario seguir interactuando con la interfaz

## Pruebas

Para probar la conexión con el backend, ejecuta:

```bash
node test_backend.js
```

Este script verifica:
1. La conexión con el backend
2. El envío y recepción de mensajes

## Despliegue

### Backend

Para ejecutar el backend en desarrollo:

```bash
python run.py
```

Para producción, considera usar Gunicorn o uWSGI con un servidor web como Nginx.

### Frontend

El frontend se integra con el resto de la aplicación AstroLab Calculator. Asegúrate de actualizar la URL del backend en producción.

## Solución de Problemas

### Problemas Comunes

1. **Error "Network request failed"**
   - Verifica que el servidor Flask esté en ejecución
   - Comprueba que la URL y el puerto sean correctos
   - Asegúrate de que CORS esté habilitado en el backend

2. **Error "La solicitud excedió el tiempo de espera"**
   - Puede indicar que el servidor está sobrecargado
   - Verifica la conexión a internet
   - Aumenta el tiempo de espera en `fetchWithTimeout`

3. **Respuestas vacías o incorrectas**
   - Verifica las claves API de OpenRouter
   - Comprueba el formato de las solicitudes y respuestas
   - Revisa los logs del servidor Flask para errores específicos

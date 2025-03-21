# Integración con Backend Flask para AstroBot

Este documento describe cómo integrar el frontend de AstroBot con el backend Flask que utiliza OpenRouter para acceder a modelos de lenguaje como GPT-3.5-turbo.

## Estructura del Backend

El backend está organizado en una estructura de carpetas para facilitar el mantenimiento y la escalabilidad:

```markdown
AstroBot/
├── app/                  # Código principal de la aplicación
│   ├── __init__.py       # Inicialización de la aplicación Flask
│   ├── ai.py             # Funciones para interactuar con OpenRouter
│   ├── config.py         # Configuración de la aplicación
│   └── routes.py         # Definición de rutas y endpoints
├── docs/                 # Documentación del proyecto
│   ├── CONFIGURACION.md  # Guía de configuración
│   ├── DOCKER_PRODUCCION.md # Guía para despliegue con Docker
│   └── ...               # Otros documentos de ayuda
├── docker/               # Archivos relacionados con Docker
│   ├── docker-compose.yml # Configuración de servicios Docker
│   ├── Dockerfile        # Instrucciones para construir la imagen
│   ├── start_docker.bat  # Script para iniciar Docker
│   └── check_docker_status.bat # Script para verificar estado
├── scripts/              # Scripts de utilidad
│   ├── start_simple.bat  # Iniciar en modo simple
│   ├── start_expo.bat    # Iniciar para dispositivos Expo
│   └── ...               # Otros scripts de configuración
├── utils/                # Utilidades y herramientas
│   ├── update_universal_config.js # Actualizar configuración
│   ├── test_expo_connection.js    # Probar conexión Expo
│   └── ...               # Otras utilidades
├── .env                  # Variables de entorno (no incluir en control de versiones)
├── instalar_y_ejecutar.bat # Script de instalación automática
├── instalar_docker.bat   # Script para instalar Docker automáticamente
├── start.bat             # Acceso rápido para iniciar en modo simple
├── start_docker.bat      # Acceso rápido para iniciar con Docker
├── start_expo.bat        # Acceso rápido para iniciar con Expo
└── run.py                # Script principal para ejecutar la aplicación
```

## Configuración del Backend

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

## Conexión con Dispositivos Móviles

El backend está configurado para ser accesible desde diferentes dispositivos:

1. **Emuladores Android**:
   - Se usa automáticamente la dirección `10.0.2.2:5000` (especial para emuladores)
   - Se configura el redireccionamiento de puertos con `adb reverse tcp:5000 tcp:5000`

2. **Dispositivos Físicos con Expo**:
   - Se usa automáticamente la dirección IP de tu máquina en la red local
   - Asegúrate de que el dispositivo esté en la misma red WiFi que tu computadora
   - **Importante**: Ejecuta `setup_firewall.bat` como administrador para permitir conexiones al puerto 5000

3. **Navegadores Web**:
   - Se usa `localhost:5000` para acceder al backend

La configuración se aplica automáticamente al ejecutar los scripts `start.bat` o `start_simple.bat`.

## Solución de Problemas con Expo

Si tienes problemas para conectar tu dispositivo Expo al backend:

1. Verifica que tu dispositivo esté en la misma red WiFi que tu computadora
2. Asegúrate de haber ejecutado `setup_firewall.bat` como administrador
3. Reinicia la aplicación Expo en tu dispositivo
4. Si sigues teniendo problemas, intenta desactivar temporalmente el firewall de Windows

## Instalación de Dependencias

Para instalar las dependencias de Python, ejecuta:

```bash
pip install -r requirements.txt
```

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

## Configuración de la comunicación Backend-Frontend

Para que el frontend pueda comunicarse correctamente con el backend, es necesario actualizar la configuración con la dirección IP correcta:

1. Asegúrate de que el backend esté en ejecución (ya sea con Docker o directamente con Python)

1. Ejecuta el script de actualización de configuración del frontend:

```bash
node update_frontend_config.js
```

1. Este script detectará automáticamente tu dirección IP local y actualizará los archivos del frontend para que apunten a tu backend.

1. Para verificar que la comunicación funciona correctamente, puedes ejecutar:

```bash
cd ../Astrolabx3/AstroLabCalculator && node test_backend.js
```

## Configuración para aplicaciones móviles React Native

Para aplicaciones móviles desarrolladas con React Native, se requiere una configuración especial:

1. Ejecuta el script de actualización para aplicaciones móviles:

```bash
node update_mobile_config.js
```

1. Este script detectará automáticamente tu dirección IP local y creará/actualizará los archivos de configuración necesarios.

1. Para emuladores Android, tienes dos opciones:
   - Usar `10.0.2.2` en lugar de `localhost`
   - Ejecutar `adb reverse tcp:5000 tcp:5000` para redirigir el puerto

1. Para dispositivos físicos, asegúrate de que estén en la misma red WiFi que tu máquina.

Para más detalles, consulta el archivo [MOBILE_CONFIG.md](./MOBILE_CONFIG.md).

## Inicio rápido

Para iniciar el backend, tienes dos opciones:

### Opción 1: Ejecución Directa con Python (Recomendada para desarrollo)

```bash
./start_simple.bat
```

Este script:

1. Inicia el backend directamente con Python
2. Actualiza la configuración del frontend y aplicaciones móviles
3. Ofrece la opción de configurar el redireccionamiento de puertos para emuladores Android

### Opción 2: Ejecución con Docker (Recomendada para producción)

```bash
./start.bat
```

Este script:

1. Detiene contenedores existentes
2. Reconstruye la imagen Docker
3. Inicia el backend con Docker
4. Actualiza la configuración del frontend y aplicaciones móviles

Para más detalles sobre las opciones de ejecución, consulta el archivo [EJECUCION.md](./EJECUCION.md).

## Prueba de conexión

Para verificar que el backend está funcionando correctamente y es accesible desde diferentes dispositivos:
```bash
node utils/test_expo_connection.js
```
Este script probará la conexión desde:
- localhost (esta máquina)
- 127.0.0.1 (loopback IP)
- Tu dirección IP real (para dispositivos en la misma red)
- 10.0.2.2 (para emuladores Android)
Y te mostrará un resumen de las URLs que funcionan correctamente.

## Solución de problemas de comunicación

### Problemas frecuentes

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

## Despliegue con Docker

### Requisitos para Docker

- Docker instalado en tu sistema
- Docker Compose instalado en tu sistema

### Configuración para Docker

1. Asegúrate de tener un archivo `.env` en la raíz del proyecto con las variables de entorno necesarias:
```bash
OPENROUTER_API_KEY=tu_clave_api_de_openrouter
OPENROUTER_API_BASE=https://openrouter.ai/api/v1
DEFAULT_MODEL=deepseek/deepseek-chat:free
```

1. Construye y ejecuta el contenedor Docker:
```bash
docker-compose up -d
```
La aplicación estará disponible en `http://localhost:5000`

1. Para detener la aplicación:
```bash
docker-compose down
```

### Ventajas de usar Docker

- Entorno de ejecución consistente y aislado
- Fácil despliegue en cualquier sistema que tenga Docker instalado
- No es necesario instalar Python ni dependencias en el sistema host
- Facilita la distribución y el despliegue del proyecto

### Solución de problemas con Docker

1. **Error al construir la imagen**
   - Verifica que el Dockerfile no tenga errores
   - Asegúrate de tener permisos suficientes para ejecutar Docker

1. **La aplicación no responde**
   - Verifica los logs del contenedor: `docker-compose logs`
   - Comprueba que los puertos estén correctamente mapeados

1. **Variables de entorno no disponibles**
   - Asegúrate de que el archivo `.env` existe y tiene el formato correcto
   - Verifica que docker-compose.yml incluya la referencia al archivo .env

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

## Configuración del Entorno

Para configurar el entorno de desarrollo, sigue estos pasos:

1. Clona este repositorio

2. Configura las variables de entorno

3. Instala las dependencias

### Dependencias necesarias

Para ejecutar el backend, necesitas:
- Python 3.8 o superior
- Las dependencias listadas en `requirements.txt`:
  - Flask
  - flask-cors
  - python-dotenv
  - requests
  - openai

# Despliegue de AstroBot Backend en Render

Esta guía te ayudará a desplegar el backend de AstroBot en Render de forma gratuita.

## Requisitos

- Una cuenta en [Render](https://render.com/)
- Tu código subido a GitHub o GitLab

## Pasos para el Despliegue

### 1. Preparar el Repositorio

Asegúrate de que tu repositorio contenga los siguientes archivos:

- `wsgi.py` - Punto de entrada para Gunicorn
- `requirements.txt` - Dependencias de Python
- `render.yaml` - Configuración para Render (opcional)
- `Procfile` - Configuración alternativa (opcional)

### 2. Crear un Nuevo Servicio Web en Render

1. Inicia sesión en [Render Dashboard](https://dashboard.render.com/)
2. Haz clic en "New" y selecciona "Web Service"
3. Conecta tu repositorio de GitHub/GitLab
4. Configura el servicio:
   - **Nombre**: astrobot-backend (o el que prefieras)
   - **Entorno**: Python
   - **Comando de construcción**: `pip install -r requirements.txt`
   - **Comando de inicio**: `gunicorn wsgi:app`

### 3. Configurar Variables de Entorno

En la sección "Environment" de tu servicio en Render, añade las siguientes variables:

- `OPENROUTER_API_KEY`: Tu clave API de OpenRouter
- `DEBUG`: False
- `LOG_LEVEL`: INFO

### 4. Desplegar el Servicio

1. Haz clic en "Create Web Service"
2. Espera a que se complete el despliegue (puede tardar unos minutos)

### 5. Verificar el Despliegue

Una vez completado el despliegue, Render te proporcionará una URL para tu servicio (por ejemplo, `https://astrobot-backend.onrender.com`).

Puedes verificar que el servicio está funcionando correctamente accediendo a:
- `https://tu-url.onrender.com/status`
- `https://tu-url.onrender.com/welcome`

### 6. Configurar el Cliente

Actualiza la configuración de tu aplicación cliente para que apunte a la nueva URL del backend:

```javascript
const API_BASE_URL = "https://tu-url.onrender.com";
```

## Limitaciones del Plan Gratuito de Render

- El servicio se suspende después de 15 minutos de inactividad
- Al recibir una nueva solicitud, el servicio se reactiva (puede tardar unos segundos)
- 512 MB de RAM
- Ancho de banda limitado

## Solución de Problemas

### Error "Failed to find attribute 'app' in 'app'"

Si encuentras este error, asegúrate de que:
1. El archivo `wsgi.py` existe y contiene `app = create_app()`
2. El comando de inicio es `gunicorn wsgi:app` (no `app:app` o `run:app`)

### Error de Tiempo de Espera

Si el servicio tarda demasiado en iniciar, puede ser debido a:
1. Dependencias pesadas que tardan en instalarse
2. Proceso de inicio lento

Intenta optimizar tu aplicación para que inicie más rápido.

### Error de Memoria Insuficiente

Si recibes errores de memoria, considera:
1. Optimizar tu aplicación para usar menos memoria
2. Actualizar a un plan de pago de Render con más recursos

## Actualización del Servicio

Para actualizar tu servicio:
1. Realiza cambios en tu repositorio y haz push
2. Render detectará automáticamente los cambios y desplegará la nueva versión

También puedes forzar un nuevo despliegue desde el dashboard de Render.

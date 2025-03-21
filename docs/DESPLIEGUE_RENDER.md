# Despliegue de AstroBot Backend en Render

Esta guía te ayudará a desplegar el backend de AstroBot en Render de forma gratuita.

## Requisitos

- Una cuenta en [Render](https://render.com/)
- Tu código subido a GitHub o GitLab

## Pasos para el Despliegue

### 1. Preparar el Repositorio

Asegúrate de que tu repositorio contenga los siguientes archivos:

- `app.py` - Punto de entrada para desarrollo local
- `run.py` - Punto de entrada para Gunicorn en producción
- `wsgi.py` - Alternativa a run.py (opcional)
- `requirements.txt` - Dependencias de Python
- `render.yaml` - Configuración para Render
- `Procfile` - Configuración alternativa (opcional)
- `gunicorn_config.py` - Configuración para Gunicorn
- `start.sh` - Script alternativo para iniciar la aplicación

### 2. Crear un Nuevo Servicio Web en Render

1. Inicia sesión en [Render Dashboard](https://dashboard.render.com/)
2. Haz clic en "New" y selecciona "Web Service"
3. Conecta tu repositorio de GitHub/GitLab
4. Configura el servicio:

   - **Nombre**: astrobot-backend (o el que prefieras)
   - **Entorno**: Python
   - **Comando de construcción**: `chmod +x render-build.sh && ./render-build.sh`
   - **Comando de inicio**: `chmod +x start.sh && ./start.sh`

### 3. Configurar Variables de Entorno

En la sección "Environment" de tu servicio en Render, añade las siguientes variables:

- `OPENROUTER_API_KEY`: Tu clave API de OpenRouter
- `DEBUG`: "False"
- `LOG_LEVEL`: "INFO"

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

1. El archivo `run.py` existe y contiene `app = create_app()`
2. El comando de inicio es `gunicorn run:app -c gunicorn_config.py`

### Error "'gunicorn_config.py' doesn't exist"

Si encuentras este error, puedes resolverlo de varias formas:

1. **Opción 1: Asegurarte de que gunicorn_config.py existe y está correctamente configurado**
   - Verifica que el archivo `gunicorn_config.py` existe en la raíz del proyecto
   - Asegúrate de que no contiene errores de sintaxis o referencias a funciones no definidas
   - Si hay hooks (como `on_starting`, `worker_exit`, etc.), asegúrate de que estén correctamente implementados o comentados

2. **Opción 2: Usar el script start.sh**
   - Asegúrate de que el archivo `start.sh` existe en la raíz del proyecto
   - Verifica que tiene permisos de ejecución (`chmod +x start.sh`)
   - El script debe contener lógica para manejar tanto el caso en que `gunicorn_config.py` exista como cuando no exista

3. **Opción 3: Cambiar el comando de inicio en el panel de Render**
   - Ve a la sección "Settings" de tu servicio en el dashboard de Render
   - Cambia el comando de inicio a: `gunicorn run:app --bind=0.0.0.0:10000 --workers=4 --worker-class=gevent --timeout=30`
   - Guarda los cambios y redespliega

### Discrepancia entre configuración manual y render.yaml

Si has configurado tu servicio manualmente a través del dashboard de Render, pero también tienes un archivo `render.yaml` en tu repositorio, es posible que haya una discrepancia entre ambas configuraciones. Para resolver esto:

1. Ve a la sección "Settings" de tu servicio en el dashboard de Render
2. Busca la opción "Use render.yaml from repository" y actívala
3. Guarda los cambios y redespliega la aplicación

También puedes forzar un nuevo despliegue desde el dashboard de Render.

### Error de Tiempo de Espera

Si el servicio tarda demasiado en iniciar, puede ser debido a:

1. Dependencias pesadas que tardan en instalarse
2. Proceso de inicio lento

Intenta optimizar tu aplicación para que inicie más rápido.

### Error de Memoria Insuficiente

Si recibes errores de memoria, considera:

1. Optimizar tu código para usar menos memoria
2. Actualizar a un plan de pago con más recursos

## Mantenimiento

Para mantener tu servicio funcionando correctamente:

1. Monitoriza los logs regularmente
2. Configura alertas para errores críticos
3. Actualiza tus dependencias periódicamente

## Recursos Adicionales

- [Documentación oficial de Render](https://render.com/docs)
- [Guía de optimización de Python para Render](https://render.com/docs/python)
- [Foro de la comunidad de Render](https://community.render.com/)

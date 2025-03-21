# Despliegue en Render

## Pasos Rápidos

1. Sube tu código a GitHub
2. Crea una cuenta en [Render](https://render.com/)
3. Crea un nuevo Web Service conectando tu repositorio
4. Configura:

   - **Entorno**: Python
   - **Comando de construcción**: `chmod +x render-build.sh && ./render-build.sh`
   - **Comando de inicio**: `gunicorn run:app --bind=0.0.0.0:10000 --workers=4 --worker-class=gevent --timeout=30`

5. Añade variables de entorno:

   - `OPENROUTER_API_KEY`: Tu clave API
   - `DEBUG`: "False"
   - `LOG_LEVEL`: "INFO"

6. Haz clic en "Create Web Service"

## Verificación

Accede a `https://tu-url.onrender.com/status` para verificar que el servicio está funcionando.

## Solución de Problemas

Si encuentras el error "Failed to find attribute 'app' in 'app'":

1. Asegúrate de que existe el archivo `run.py` con `app = create_app()`
2. Verifica que el comando de inicio es `gunicorn run:app --bind=0.0.0.0:10000 --workers=4 --worker-class=gevent --timeout=30`
3. Actualiza la configuración en el dashboard de Render

Si encuentras el error "'gunicorn_config.py' doesn't exist":

1. Cambia el comando de inicio para incluir los parámetros directamente:
   ```
   gunicorn run:app --bind=0.0.0.0:10000 --workers=4 --worker-class=gevent --timeout=30
   ```
2. Actualiza tanto `render.yaml` como `Procfile` con este comando

## Limitaciones del Plan Gratuito

- Suspensión después de 15 minutos de inactividad
- 512 MB de RAM
- Ancho de banda limitado

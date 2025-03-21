# Guía de Despliegue en Producción con Docker

Este documento explica cómo desplegar el backend de AstroBot en un entorno de producción utilizando Docker.

## Requisitos

- Docker y Docker Compose instalados
- Acceso a Internet para descargar las imágenes base
- Puerto 5000 disponible en el servidor

## Archivos de Configuración

El despliegue con Docker utiliza los siguientes archivos:

- `Dockerfile`: Define cómo se construye la imagen del contenedor
- `docker-compose.yml`: Define cómo se ejecuta el contenedor y sus configuraciones
- `start_docker.bat`: Script para iniciar el contenedor fácilmente
- `check_docker_status.bat`: Script para verificar el estado del contenedor

## Características de Seguridad y Rendimiento

La configuración de Docker incluye:

- **Usuario no privilegiado**: La aplicación se ejecuta como un usuario sin privilegios dentro del contenedor
- **Límites de recursos**: Se limita el uso de CPU y memoria para evitar problemas de rendimiento
- **Healthcheck**: Verificación periódica del estado de la aplicación
- **Rotación de logs**: Configuración para evitar que los logs ocupen demasiado espacio
- **Reinicio automático**: El contenedor se reinicia automáticamente en caso de fallo

## Pasos para el Despliegue

### 1. Preparación

Asegúrate de tener el archivo `.env` configurado correctamente con tus claves API y otras configuraciones.

### 2. Construcción e Inicio

Ejecuta el script `start_docker.bat` para construir e iniciar el contenedor:

```bash
start_docker.bat
```

Este script:

 
- Detiene contenedores existentes
- Construye la imagen Docker
- Inicia el contenedor
- Actualiza la configuración del frontend


### 3. Verificación

Ejecuta el script `check_docker_status.bat` para verificar que todo funciona correctamente:

```bash
check_docker_status.bat
```

### 4. Acceso

El backend estará disponible en:

- URL local: [http://localhost:5000](http://localhost:5000)
- Desde otros dispositivos: [http://[IP-DEL-SERVIDOR]:5000](http://[IP-DEL-SERVIDOR]:5000)

## Mantenimiento

### Visualización de Logs

Para ver los logs del contenedor:

```bash
docker logs astrobot-backend
```

Para seguir los logs en tiempo real:

```bash
docker logs -f astrobot-backend
```

### Reinicio del Contenedor

Si necesitas reiniciar el contenedor:

```bash
docker-compose restart
```

### Actualización

Para actualizar a una nueva versión del código:

1. Detén el contenedor:

   ```bash
   docker-compose down
   ```

2. Actualiza el código fuente (git pull, etc.)

3. Reconstruye e inicia:

   ```bash
   start_docker.bat
   ```

## Solución de Problemas

### El Contenedor No Inicia

Verifica los logs para identificar el problema:

```bash
docker-compose logs
```

### Problemas de Conexión

Si no puedes conectarte al backend:

1. Verifica que el contenedor esté en ejecución:

   ```bash
   docker ps
   ```

2. Comprueba si hay errores en los logs:

   ```bash
   docker logs astrobot-backend
   ```

3. Asegúrate de que el puerto 5000 esté abierto en el firewall:

   ```bash
   setup_firewall.bat
   ```

## Configuración Avanzada

### Cambio de Puerto

Si necesitas cambiar el puerto, edita el archivo `docker-compose.yml`:

```yaml
ports:
  - "NUEVO_PUERTO:5000"
```

Y luego reinicia el contenedor.

### Aumento de Recursos

Si la aplicación necesita más recursos, edita los límites en `docker-compose.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '2'
      memory: 1G
```

## Recomendaciones Finales

- Mantén siempre una copia de seguridad de la carpeta `app` y el archivo `.env`
- Monitoriza regularmente el uso de recursos del contenedor
- Actualiza periódicamente la imagen base de Python para obtener parches de seguridad

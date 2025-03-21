# Guía de Despliegue en Producción para AstroBot Backend

Esta guía te ayudará a desplegar el backend de AstroBot en un servidor de producción para que puedas acceder a él desde cualquier lugar.

## Opciones de Despliegue

Hay varias opciones para desplegar el backend en producción:

1. **VPS (Servidor Privado Virtual)** - Opción recomendada para control total
2. **Servicios de Contenedores en la Nube** - Como AWS ECS, Google Cloud Run, Azure Container Instances
3. **Plataformas PaaS** - Como Heroku, DigitalOcean App Platform, Render

Esta guía se enfocará en la opción de VPS por ser la más flexible y económica.

## Requisitos Previos

- Un servidor VPS con Ubuntu 20.04 o superior
- Acceso SSH al servidor
- Un nombre de dominio (opcional pero recomendado)

## Pasos para el Despliegue en un VPS

### 1. Preparar el Servidor

Conéctate a tu servidor mediante SSH:

```bash
ssh usuario@ip-del-servidor
```

Actualiza el sistema:

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Instalar Git y Clonar el Repositorio

```bash
sudo apt install git -y
git clone https://tu-repositorio/astrobot.git
cd astrobot
```

### 3. Configurar Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto:

```bash
cp .env.example .env
nano .env
```

Edita el archivo para incluir tu clave API de OpenRouter y otras configuraciones:

```makefile
OPENROUTER_API_KEY=tu-clave-api
DEBUG=False
LOG_LEVEL=INFO
```

### 4. Ejecutar el Script de Despliegue

Hemos incluido un script de despliegue que automatiza la instalación de Docker y el despliegue del backend:

```bash
chmod +x deploy.sh
./deploy.sh
```

El script realizará las siguientes acciones:
 
- Verificar e instalar Docker y Docker Compose si es necesario
- Configurar el firewall para permitir el tráfico necesario
- Construir y levantar los contenedores Docker
- Mostrar la URL donde está disponible el backend

### 5. Configurar un Proxy Inverso con Nginx y SSL (Recomendado)

Para mayor seguridad y profesionalismo, es recomendable configurar Nginx como proxy inverso y habilitar SSL:

```bash
sudo apt install nginx certbot python3-certbot-nginx -y
```

Crea una configuración de Nginx:

```bash
sudo nano /etc/nginx/sites-available/astrobot
```

Añade la siguiente configuración:

```nginx
server {
    listen 80;
    server_name tudominio.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Habilita la configuración:

```bash
sudo ln -s /etc/nginx/sites-available/astrobot /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

Configura SSL con Certbot:

```bash
sudo certbot --nginx -d tudominio.com
```

### 6. Actualizar la Configuración del Cliente

Actualiza la configuración de tu aplicación cliente para que apunte a la nueva URL del backend:
 
- Para aplicaciones web: `https://tudominio.com`
- Para aplicaciones móviles: `https://tudominio.com` o la IP pública del servidor

## Mantenimiento y Monitoreo

### Verificar el Estado del Servicio

```bash
docker-compose -f docker/docker-compose.yml ps
```

### Ver Logs

```bash
docker-compose -f docker/docker-compose.yml logs -f
```

### Reiniciar el Servicio

```bash
docker-compose -f docker/docker-compose.yml restart
```

### Actualizar el Backend

Para actualizar a una nueva versión:

```bash
git pull
docker-compose -f docker/docker-compose.yml down
docker-compose -f docker/docker-compose.yml up -d --build
```

## Solución de Problemas

### El Backend No Responde

Verifica que los contenedores estén en ejecución:

```bash
docker ps
```

Verifica los logs:

```bash
docker-compose -f docker/docker-compose.yml logs
```

### Problemas de Conexión desde el Cliente

- Asegúrate de que el puerto 5000 (o 80/443 si usas Nginx) esté abierto en el firewall
- Verifica que la URL configurada en el cliente sea correcta
- Prueba la conexión con curl desde otro servidor:
 
  ```bash
  curl https://tudominio.com/status
  ```

## Recomendaciones de Seguridad

1. **Nunca expongas directamente el puerto 5000** - Siempre usa un proxy inverso como Nginx
2. **Habilita SSL** - Usa Certbot para obtener certificados gratuitos de Let's Encrypt
3. **Configura un firewall** - Limita el acceso solo a los puertos necesarios
4. **Actualiza regularmente** - Mantén el sistema y las dependencias actualizadas
5. **Configura backups** - Realiza copias de seguridad periódicas de tu configuración

## Recursos Adicionales

- [Documentación de Docker](https://docs.docker.com/)
- [Documentación de Nginx](https://nginx.org/en/docs/)
- [Tutoriales de DigitalOcean sobre despliegue](https://www.digitalocean.com/community/tutorials)

#!/bin/bash
# Script para desplegar AstroBot en un servidor de producción

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}===== Desplegando AstroBot Backend en Producción =====${NC}"

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker no está instalado. Instalando...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Docker instalado correctamente. Por favor, cierra sesión y vuelve a iniciarla para aplicar los cambios.${NC}"
    exit 1
fi

# Verificar si Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Docker Compose no está instalado. Instalando...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Docker Compose instalado correctamente.${NC}"
fi

# Verificar si existe el archivo .env
if [ ! -f .env ]; then
    echo -e "${YELLOW}No se encontró el archivo .env. Creando uno de ejemplo...${NC}"
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${YELLOW}Por favor, edita el archivo .env con tus configuraciones antes de continuar.${NC}"
        echo -e "${YELLOW}Especialmente, asegúrate de configurar OPENROUTER_API_KEY.${NC}"
        exit 1
    else
        echo -e "${RED}No se encontró el archivo .env.example. No se puede continuar.${NC}"
        exit 1
    fi
fi

# Configurar el firewall (si es necesario)
echo -e "${GREEN}Configurando firewall...${NC}"
sudo ufw allow 5000/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp

# Detener contenedores existentes
echo -e "${GREEN}Deteniendo contenedores existentes...${NC}"
docker-compose -f docker/docker-compose.yml down

# Construir y levantar los contenedores
echo -e "${GREEN}Construyendo y levantando contenedores...${NC}"
docker-compose -f docker/docker-compose.yml up -d --build

# Verificar que el servicio esté funcionando
echo -e "${GREEN}Verificando que el servicio esté funcionando...${NC}"
sleep 5
if curl -s http://localhost:5000/status | grep -q "ok"; then
    echo -e "${GREEN}¡El servicio está funcionando correctamente!${NC}"
    
    # Obtener la IP pública del servidor
    PUBLIC_IP=$(curl -s ifconfig.me)
    echo -e "${GREEN}===== Despliegue completado =====${NC}"
    echo -e "${GREEN}El backend está disponible en:${NC}"
    echo -e "${YELLOW}http://$PUBLIC_IP:5000${NC}"
    
    echo -e "${GREEN}Para acceder desde aplicaciones cliente, usa esta URL en la configuración.${NC}"
    echo -e "${YELLOW}Para mayor seguridad, considera configurar un proxy inverso con HTTPS.${NC}"
else
    echo -e "${RED}¡El servicio no está funcionando correctamente!${NC}"
    echo -e "${RED}Revisa los logs con: docker-compose -f docker/docker-compose.yml logs${NC}"
fi

// Script para actualizar la configuración de la aplicación Expo para dispositivos físicos
const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

// Función para obtener la dirección IP local
function getLocalIpAddress() {
    try {
        // Obtener la dirección IP mediante ipconfig
        const output = execSync('ipconfig').toString();
        
        // Buscar direcciones IPv4 que no sean de WSL o virtuales
        const ipv4Matches = output.match(/Dirección IPv4[.\s]+: ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/g);
        
        if (ipv4Matches && ipv4Matches.length > 0) {
            // Filtrar direcciones que no son 127.0.0.1 o 172.x.x.x (WSL)
            for (const match of ipv4Matches) {
                const ipMatch = match.match(/([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/);
                if (ipMatch && ipMatch[1]) {
                    const ip = ipMatch[1];
                    if (!ip.startsWith('127.') && !ip.startsWith('172.')) {
                        console.log(`Dirección IP local detectada: ${ip}`);
                        return ip;
                    }
                }
            }
        }
        
        // Si no encontramos una IP adecuada, intentar con interfaces de red
        const interfaces = os.networkInterfaces();
        let ipAddress = null;
        
        // Buscar una dirección IPv4 que no sea interna
        Object.keys(interfaces).forEach((ifname) => {
            interfaces[ifname].forEach((iface) => {
                // Ignorar direcciones IPv6, direcciones de loopback y direcciones WSL
                if (iface.family === 'IPv4' && !iface.internal && 
                    !iface.address.startsWith('127.') && !iface.address.startsWith('172.')) {
                    ipAddress = iface.address;
                }
            });
        });
        
        if (ipAddress) {
            console.log(`Dirección IP local detectada: ${ipAddress}`);
            return ipAddress;
        }
        
        console.log('No se encontró una dirección IPv4 adecuada, usando 192.168.100.129');
        return '192.168.100.129'; // Dirección IP detectada en tu red
    } catch (error) {
        console.error('Error al obtener la dirección IP:', error.message);
        return '192.168.100.129'; // Dirección IP detectada en tu red
    }
}

// Ruta al archivo de servicio AstroBotService.js
const servicePath = path.resolve(__dirname, '..', 'Astrolabx3', 'AstroLabCalculator', 'src', 'services', 'AstroBotService.js');

// Obtener la dirección IP local
const localIp = getLocalIpAddress();

console.log(`Actualizando configuración para Expo en: ${servicePath}`);

// Verificar si el archivo existe
if (fs.existsSync(servicePath)) {
    // Leer el contenido del archivo
    let content = fs.readFileSync(servicePath, 'utf8');
    
    // Crear un nuevo contenido para la configuración de la URL
    const configSection = `// AstroBotService.js
// Servicio para manejar la comunicación con el backend de AstroBot

import { Platform } from 'react-native';

// URL base para el backend de AstroBot
// Configuración específica para Expo en dispositivos físicos
const API_BASE_URL = 'http://${localIp}:5000';

console.log('AstroBot API URL para Expo:', API_BASE_URL);`;
    
    // Reemplazar la sección de configuración
    const updatedContent = content.replace(
        /\/\/ AstroBotService\.js[\s\S]*?const API_BASE_URL[\s\S]*?console\.log\('AstroBot API URL[^;]*;/,
        `${configSection}`
    );
    
    // Escribir el contenido actualizado
    fs.writeFileSync(servicePath, updatedContent);
    console.log('✅ Configuración para Expo actualizada correctamente.');
    console.log(`La aplicación Expo ahora usará directamente la IP: http://${localIp}:5000`);
    
    // Crear un archivo de configuración para Expo
    const expoConfigPath = path.resolve(__dirname, '..', 'Astrolabx3', 'AstroLabCalculator', 'expo-config.json');
    const expoConfig = {
        apiBaseUrl: `http://${localIp}:5000`,
        ipAddress: localIp
    };
    
    fs.writeFileSync(expoConfigPath, JSON.stringify(expoConfig, null, 2));
    console.log(`✅ Archivo de configuración para Expo creado en: ${expoConfigPath}`);
    
    // Instrucciones adicionales
    console.log('\nPara que la conexión funcione correctamente en dispositivos Expo:');
    console.log('1. Asegúrate de que el dispositivo esté en la misma red WiFi que tu computadora');
    console.log('2. Ejecuta el script setup_firewall.bat como administrador para abrir el puerto 5000');
    console.log('3. Reinicia la aplicación Expo en tu dispositivo');
} else {
    console.log('❌ No se encontró el archivo de servicio AstroBotService.js');
    console.log(`Ruta buscada: ${servicePath}`);
}

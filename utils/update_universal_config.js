// Script para actualizar la configuración de la aplicación React Native para todos los dispositivos
const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

// Función para obtener la dirección IP local
function getLocalIpAddress() {
    try {
        // Obtener todas las interfaces de red
        const interfaces = os.networkInterfaces();
        let ipAddress = null;
        
        // Buscar una dirección IPv4 que no sea interna
        Object.keys(interfaces).forEach((ifname) => {
            interfaces[ifname].forEach((iface) => {
                // Ignorar direcciones IPv6 y direcciones de loopback
                if (iface.family === 'IPv4' && !iface.internal) {
                    ipAddress = iface.address;
                }
            });
        });
        
        if (ipAddress) {
            console.log(`Dirección IP local detectada: ${ipAddress}`);
            return ipAddress;
        }
        
        // Si no se encuentra una IP externa, intentar con ipconfig
        const output = execSync('ipconfig').toString();
        const ipv4Matches = output.match(/IPv4 Address[.\s]+: ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/g);
        
        if (ipv4Matches && ipv4Matches.length > 0) {
            const ipMatch = ipv4Matches[0].match(/([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/);
            if (ipMatch && ipMatch[1]) {
                console.log(`Dirección IP local detectada desde ipconfig: ${ipMatch[1]}`);
                return ipMatch[1];
            }
        }
        
        console.log('No se encontró una dirección IPv4 externa, usando 127.0.0.1');
        return '127.0.0.1';
    } catch (error) {
        console.error('Error al obtener la dirección IP:', error.message);
        return '127.0.0.1';
    }
}

// Ruta al archivo de servicio AstroBotService.js
const servicePath = path.resolve(__dirname, '..', 'Astrolabx3', 'AstroLabCalculator', 'src', 'services', 'AstroBotService.js');

// Obtener la dirección IP local
const localIp = getLocalIpAddress();

console.log(`Actualizando configuración en: ${servicePath}`);

// Verificar si el archivo existe
if (fs.existsSync(servicePath)) {
    // Leer el contenido del archivo
    let content = fs.readFileSync(servicePath, 'utf8');
    
    // Crear un nuevo contenido para la configuración de la URL
    const configSection = `// AstroBotService.js
// Servicio para manejar la comunicación con el backend de AstroBot

import { Platform } from 'react-native';

// URL base para el backend de AstroBot
// Configuración dinámica para diferentes entornos
let API_BASE_URL;

// Detectar automáticamente el entorno
if (typeof document !== 'undefined') {
    // Estamos en un navegador web (React Web)
    API_BASE_URL = 'http://localhost:5000';
} else {
    // Estamos en React Native
    if (Platform.OS === 'android') {
        // En Android, intentamos usar diferentes opciones
        try {
            // Para emuladores Android, usar 10.0.2.2
            if (__DEV__ && global.isEmulator) {
                API_BASE_URL = 'http://10.0.2.2:5000';
            } else {
                // Para dispositivos físicos, usar la IP real
                API_BASE_URL = 'http://${localIp}:5000';
            }
        } catch (error) {
            // Si hay un error, usar la IP real como fallback
            API_BASE_URL = 'http://${localIp}:5000';
        }
    } else if (Platform.OS === 'ios') {
        // En iOS, usar localhost para simuladores y la IP real para dispositivos físicos
        if (__DEV__ && global.isEmulator) {
            API_BASE_URL = 'http://localhost:5000';
        } else {
            API_BASE_URL = 'http://${localIp}:5000';
        }
    } else {
        // Fallback para otros entornos
        API_BASE_URL = 'http://${localIp}:5000';
    }
}

// Mostrar la URL configurada
console.log('AstroBot API URL:', API_BASE_URL);`;
    
    // Reemplazar la sección de configuración
    const updatedContent = content.replace(
        /\/\/ AstroBotService\.js[\s\S]*?console\.log\('AstroBot API URL[^;]*;/,
        `${configSection}`
    );
    
    // Escribir el contenido actualizado
    fs.writeFileSync(servicePath, updatedContent);
    console.log('✅ Configuración universal actualizada correctamente.');
    console.log('La aplicación ahora detectará automáticamente el entorno y usará la URL adecuada.');
    console.log('- Emuladores Android: http://10.0.2.2:5000');
    console.log(`- Dispositivos físicos: http://${localIp}:5000`);
    console.log('- Web: http://localhost:5000');
    
    // Verificar la regla del firewall
    try {
        const firewallOutput = execSync('netsh advfirewall firewall show rule name="AstroBot Backend"').toString();
        console.log(`\n✅ Regla de firewall configurada correctamente.`);
    } catch (error) {
        console.log(`\n⚠️ La regla de firewall "AstroBot Backend" no está configurada.`);
        console.log(`Por favor, ejecuta setup_firewall.bat como administrador.`);
    }
    
    // Probar la conexión
    try {
        console.log(`\nProbando conexión al backend...`);
        const response = execSync(`curl -s http://${localIp}:5000/status`).toString();
        console.log(`✅ Backend accesible en http://${localIp}:5000`);
    } catch (error) {
        console.log(`❌ No se pudo conectar al backend en http://${localIp}:5000`);
        console.log(`Asegúrate de que el backend esté en ejecución.`);
    }
} else {
    console.log('❌ No se encontró el archivo de servicio AstroBotService.js');
    console.log(`Ruta buscada: ${servicePath}`);
}

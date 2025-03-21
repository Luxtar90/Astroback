// Script para probar la conexión desde Expo a AstroBot Backend
const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

// Función para obtener la dirección IP local (la misma que en update_expo_config.js)
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
        
        // Si no encontramos una IP adecuada, usar la IP detectada anteriormente
        return '192.168.100.129';
    } catch (error) {
        console.error('Error al obtener la dirección IP:', error.message);
        return '192.168.100.129';
    }
}

// Obtener la dirección IP local
const localIp = getLocalIpAddress();
const url = `http://${localIp}:5000/status`;

console.log(`\n===== Prueba de Conexión para Expo =====`);
console.log(`Probando conexión a: ${url}`);
console.log(`Esta es la URL que usará tu dispositivo Expo para conectarse al backend.`);
console.log(`\nVerificando si el backend está en ejecución...`);

// Función para probar la conexión con timeout
function testConnection(url, timeoutMs = 5000) {
    return new Promise((resolve, reject) => {
        const startTime = Date.now();
        
        const req = http.get(url, (res) => {
            const endTime = Date.now();
            const responseTime = endTime - startTime;
            
            let data = '';
            res.on('data', (chunk) => {
                data += chunk;
            });
            
            res.on('end', () => {
                try {
                    const response = JSON.parse(data);
                    resolve({
                        status: res.statusCode,
                        data: response,
                        responseTime
                    });
                } catch (error) {
                    resolve({
                        status: res.statusCode,
                        data: data,
                        responseTime
                    });
                }
            });
        });
        
        req.on('error', (error) => {
            reject(error);
        });
        
        // Configurar timeout
        req.setTimeout(timeoutMs, () => {
            req.abort();
            reject(new Error(`La solicitud excedió el tiempo de espera (${timeoutMs}ms)`));
        });
    });
}

// Probar la conexión
testConnection(url)
    .then((response) => {
        console.log(`\n✅ Conexión exitosa!`);
        console.log(`Tiempo de respuesta: ${response.responseTime}ms`);
        console.log(`Estado del backend: ${JSON.stringify(response.data, null, 2)}`);
        console.log(`\nTu dispositivo Expo debería poder conectarse correctamente al backend.`);
        
        // Verificar la regla del firewall
        try {
            const firewallOutput = execSync('netsh advfirewall firewall show rule name="AstroBot Backend"').toString();
            console.log(`\n✅ Regla de firewall configurada correctamente.`);
        } catch (error) {
            console.log(`\n⚠️ La regla de firewall "AstroBot Backend" no está configurada.`);
            console.log(`Por favor, ejecuta setup_firewall.bat como administrador.`);
        }
        
        // Verificar si el dispositivo está en la misma red
        console.log(`\nPara que la conexión funcione en tu dispositivo Expo:`);
        console.log(`1. Asegúrate de que tu dispositivo esté en la misma red WiFi que este equipo`);
        console.log(`2. La aplicación Expo debe estar configurada para usar la IP: ${localIp}`);
        console.log(`3. Si sigues teniendo problemas, verifica que no haya otro firewall bloqueando el puerto 5000`);
    })
    .catch((error) => {
        console.log(`\n❌ Error de conexión: ${error.message}`);
        
        // Verificar si el backend está en ejecución
        try {
            const processes = execSync('tasklist | findstr python').toString();
            if (processes.includes('python')) {
                console.log(`\n✅ El backend de Python parece estar en ejecución.`);
            } else {
                console.log(`\n❌ No se detectó ningún proceso de Python en ejecución.`);
                console.log(`Por favor, ejecuta start_simple.bat para iniciar el backend.`);
            }
        } catch (error) {
            console.log(`\n❌ No se detectó ningún proceso de Python en ejecución.`);
            console.log(`Por favor, ejecuta start_simple.bat para iniciar el backend.`);
        }
        
        // Verificar la regla del firewall
        try {
            const firewallOutput = execSync('netsh advfirewall firewall show rule name="AstroBot Backend"').toString();
            console.log(`\n✅ Regla de firewall configurada correctamente.`);
        } catch (error) {
            console.log(`\n❌ La regla de firewall "AstroBot Backend" no está configurada.`);
            console.log(`Por favor, ejecuta setup_firewall.bat como administrador.`);
        }
        
        console.log(`\nPasos para solucionar problemas de conexión:`);
        console.log(`1. Asegúrate de que el backend esté en ejecución (start_simple.bat)`);
        console.log(`2. Ejecuta setup_firewall.bat como administrador`);
        console.log(`3. Verifica que tu dispositivo esté en la misma red WiFi que este equipo (${localIp})`);
        console.log(`4. Reinicia la aplicación Expo en tu dispositivo`);
    })
    .finally(() => {
        console.log(`\n===== Fin de la Prueba =====\n`);
    });

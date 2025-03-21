// Script para probar la conexión específicamente con la IP de WSL
const http = require('http');
const { execSync } = require('child_process');

const wslIp = '172.18.112.1';
const url = `http://${wslIp}:5000/status`;

console.log(`\n===== Prueba de Conexión con IP de WSL =====`);
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
        console.log(`\n✅ Conexión exitosa con la IP de WSL (${wslIp})!`);
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
        
        console.log(`\nPara que la conexión funcione en tu dispositivo Expo:`);
        console.log(`1. Asegúrate de que tu dispositivo esté en la misma red WiFi que este equipo`);
        console.log(`2. La aplicación Expo debe estar configurada para usar la IP: ${wslIp}`);
        console.log(`3. Si sigues teniendo problemas, verifica que no haya otro firewall bloqueando el puerto 5000`);
        
        // Instrucciones adicionales para WSL
        console.log(`\n===== Información Adicional sobre WSL =====`);
        console.log(`La dirección IP ${wslIp} corresponde a la interfaz de WSL (Windows Subsystem for Linux).`);
        console.log(`Esta IP es accesible desde tu PC Windows, pero puede que no sea accesible desde otros dispositivos en tu red.`);
        console.log(`Si los dispositivos Expo no pueden conectarse usando esta IP, prueba con la IP de tu tarjeta de red física.`);
    })
    .catch((error) => {
        console.log(`\n❌ Error de conexión: ${error.message}`);
        
        // Verificar si el backend está en ejecución
        try {
            const processes = execSync('tasklist | findstr python').toString();
            if (processes.includes('python')) {
                console.log(`\n✅ El backend de Python parece estar en ejecución.`);
                console.log(`Pero no se puede conectar a la IP de WSL (${wslIp}).`);
                console.log(`Esto puede indicar un problema con la configuración de red de WSL.`);
            } else {
                console.log(`\n❌ El backend de Python no parece estar en ejecución.`);
                console.log(`Ejecuta start_expo.bat para iniciar el backend.`);
            }
        } catch (error) {
            console.log(`\n❌ No se pudo verificar si el backend está en ejecución.`);
        }
    });

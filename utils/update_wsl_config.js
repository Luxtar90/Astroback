// Script para actualizar la configuración de la aplicación Expo para usar la IP de WSL
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// IP de WSL
const wslIp = '172.18.112.1';

// Ruta al archivo de servicio AstroBotService.js
const servicePath = path.resolve(__dirname, '..', 'Astrolabx3', 'AstroLabCalculator', 'src', 'services', 'AstroBotService.js');

console.log(`Actualizando configuración para usar la IP de WSL en: ${servicePath}`);

// Verificar si el archivo existe
if (fs.existsSync(servicePath)) {
    // Leer el contenido del archivo
    let content = fs.readFileSync(servicePath, 'utf8');
    
    // Crear un nuevo contenido para la configuración de la URL
    const configSection = `// AstroBotService.js
// Servicio para manejar la comunicación con el backend de AstroBot

import { Platform } from 'react-native';

// URL base para el backend de AstroBot
// Configuración específica para usar la IP de WSL
const API_BASE_URL = 'http://${wslIp}:5000';

console.log('AstroBot API URL:', API_BASE_URL);`;
    
    // Reemplazar la sección de configuración
    const updatedContent = content.replace(
        /\/\/ AstroBotService\.js[\s\S]*?const API_BASE_URL[\s\S]*?console\.log\('AstroBot API URL[^;]*;/,
        `${configSection}`
    );
    
    // Escribir el contenido actualizado
    fs.writeFileSync(servicePath, updatedContent);
    console.log('✅ Configuración actualizada correctamente para usar la IP de WSL.');
    console.log(`La aplicación Expo ahora usará la IP de WSL: http://${wslIp}:5000`);
    
    // Crear un archivo de configuración para Expo
    const expoConfigPath = path.resolve(__dirname, '..', 'Astrolabx3', 'AstroLabCalculator', 'expo-config.json');
    const expoConfig = {
        apiBaseUrl: `http://${wslIp}:5000`,
        ipAddress: wslIp,
        isWslIp: true
    };
    
    fs.writeFileSync(expoConfigPath, JSON.stringify(expoConfig, null, 2));
    console.log(`✅ Archivo de configuración para Expo creado en: ${expoConfigPath}`);
    
    // Información adicional sobre WSL
    console.log('\n===== Información sobre la IP de WSL =====');
    console.log(`La dirección IP ${wslIp} corresponde a la interfaz de WSL (Windows Subsystem for Linux).`);
    console.log('Esta IP es accesible desde tu PC Windows, pero puede que no sea accesible desde otros dispositivos en tu red.');
    console.log('Si los dispositivos Expo no pueden conectarse usando esta IP, prueba con la IP de tu tarjeta de red física.');
    
    // Verificar si el backend está en ejecución
    try {
        const response = execSync(`curl -s http://${wslIp}:5000/status`).toString();
        console.log('\n✅ El backend está en ejecución y responde correctamente.');
        console.log(`Respuesta: ${response.trim()}`);
    } catch (error) {
        console.log('\n⚠️ No se pudo conectar al backend. Asegúrate de que esté en ejecución.');
        console.log('Ejecuta start_expo.bat para iniciar el backend.');
    }
    
    // Verificar la regla del firewall
    try {
        execSync('netsh advfirewall firewall show rule name="AstroBot Backend"').toString();
        console.log('\n✅ La regla de firewall está configurada correctamente.');
    } catch (error) {
        console.log('\n⚠️ La regla de firewall no está configurada. Ejecuta setup_firewall.bat como administrador.');
    }
    
    console.log('\nPara que la conexión funcione en tu dispositivo Expo:');
    console.log('1. Asegúrate de que tu dispositivo esté en la misma red WiFi que este equipo');
    console.log('2. Reinicia la aplicación Expo en tu dispositivo');
    console.log('3. Si sigues teniendo problemas, prueba con la IP de tu tarjeta de red física');
} else {
    console.error(`❌ No se encontró el archivo AstroBotService.js en la ruta esperada: ${servicePath}`);
}

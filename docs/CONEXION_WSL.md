# Conexión con AstroBot Backend a través de WSL

Este documento explica cómo conectar dispositivos Expo al backend de AstroBot utilizando la interfaz de red de WSL (Windows Subsystem for Linux).

## ¿Qué es la IP de WSL?

La dirección IP `172.18.112.1` corresponde a la interfaz de red virtual creada por WSL (Windows Subsystem for Linux). Esta interfaz permite la comunicación entre Windows y el subsistema Linux.

## Ventajas y Limitaciones

**Ventajas:**
- Es una IP estable que no cambia entre reinicios
- Funciona bien para pruebas locales desde el mismo PC

**Limitaciones:**
- Puede no ser accesible desde otros dispositivos en la red
- Requiere configuración adicional para ser accesible desde el exterior

## Configuración para Usar la IP de WSL

1. Ejecuta el script `update_wsl_config.js` para configurar la aplicación:
   ```bash
   node update_wsl_config.js
   ```

2. Inicia el backend con la configuración de WSL:
   ```bash
   .\start_expo_wsl.bat
   ```

3. Verifica que la conexión funcione:
   ```bash
   node test_wsl_connection.js
   ```

## Solución de Problemas

### Si tu dispositivo Expo no puede conectarse a la IP de WSL

1. **La IP de WSL no es accesible desde el exterior**
   
   Por defecto, la IP de WSL (`172.18.112.1`) solo es accesible desde tu PC Windows, no desde otros dispositivos en la red. Para solucionar esto:

   - Usa la IP de tu tarjeta de red física en lugar de la IP de WSL:
     ```bash
     node update_expo_config.js
     ```

   - Reinicia la aplicación Expo en tu dispositivo

2. **Configuración del Firewall**

   Asegúrate de que el firewall permita conexiones al puerto 5000:
   
   - Ejecuta `setup_firewall.bat` como administrador

3. **Verificación de la Red**

   - Asegúrate de que tu dispositivo esté en la misma red WiFi que tu PC
   - Verifica que no haya restricciones en la red que bloqueen las conexiones

## Pruebas Adicionales

Para verificar si el backend está funcionando correctamente:

1. **Prueba desde el navegador de tu PC**:
   - Abre `http://172.18.112.1:5000/status` en tu navegador
   - Deberías ver una respuesta JSON con el estado del servidor

2. **Prueba desde el navegador de tu dispositivo móvil**:
   - Abre `http://172.18.112.1:5000/status` en el navegador de tu dispositivo
   - Si no funciona, prueba con la IP de tu tarjeta de red física

## Alternativas

Si la conexión a través de WSL no funciona, tienes estas alternativas:

1. **Usar la IP de tu tarjeta de red física**:
   ```bash
   node update_expo_config.js
   ```

2. **Configurar Port Forwarding en tu router**:
   - Configura tu router para redirigir el puerto 5000 a tu PC
   - Usa la IP pública de tu router para conectarte desde el exterior

3. **Usar un servicio de túnel como ngrok**:
   - Instala ngrok: `npm install -g ngrok`
   - Crea un túnel: `ngrok http 5000`
   - Usa la URL proporcionada por ngrok en tu aplicación Expo

## Comandos Útiles

- `start_expo_wsl.bat`: Inicia el backend con la configuración de WSL
- `update_wsl_config.js`: Configura la aplicación para usar la IP de WSL
- `test_wsl_connection.js`: Prueba la conexión con la IP de WSL
- `setup_firewall.bat`: Configura el firewall (ejecutar como administrador)

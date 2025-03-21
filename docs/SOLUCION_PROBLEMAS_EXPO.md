# Solución de Problemas de Conexión con Expo

Este documento proporciona una guía completa para solucionar los problemas de conexión entre dispositivos Expo y el backend de AstroBot.

## Problemas Comunes

El error más común que puedes encontrar es:

```
ERROR [AstroBot] Error al conectar con el backend: La solicitud excedió el tiempo de espera (5000ms)
LOG Sin conexión con el backend: La solicitud excedió el tiempo de espera (5000ms)
```

Este error indica que tu dispositivo Expo no puede conectarse al backend de AstroBot. Hay varias causas posibles:

## Paso 1: Verificar la Red WiFi

**Es CRÍTICO que tu dispositivo Expo esté en la misma red WiFi que tu PC.**

- Verifica que ambos dispositivos estén conectados a la misma red WiFi
- Algunas redes públicas o corporativas pueden bloquear las conexiones entre dispositivos

## Paso 2: Configurar el Firewall de Windows

Windows Firewall puede estar bloqueando las conexiones entrantes al puerto 5000:

1. Ejecuta `setup_firewall.bat` como administrador:
   - Haz clic derecho en el archivo
   - Selecciona "Ejecutar como administrador"

2. Verifica que la regla se haya creado correctamente:
   ```
   netsh advfirewall firewall show rule name="AstroBot Backend"
   ```

## Paso 3: Usar la IP Correcta

El backend debe estar configurado para usar la IP correcta de tu PC:

1. Ejecuta `update_expo_config.js` para actualizar la configuración:
   ```
   node update_expo_config.js
   ```

2. Esto actualizará el archivo `AstroBotService.js` para usar la IP correcta de tu PC.

## Paso 4: Reiniciar Todo

A veces, reiniciar todos los componentes puede resolver el problema:

1. Ejecuta `restart_expo_app.bat` para reiniciar todo el sistema:
   ```
   .\restart_expo_app.bat
   ```

2. Cierra completamente la aplicación Expo en tu dispositivo (no solo minimizarla)
3. Vuelve a abrir la aplicación Expo

## Paso 5: Diagnóstico Completo

Si sigues teniendo problemas, ejecuta la herramienta de diagnóstico:

```
node fix_expo_connection.js
```

Esta herramienta verificará:
- Si el backend está en ejecución
- Si el firewall está configurado correctamente
- Si la IP configurada es correcta
- Si se puede conectar a todas las IPs disponibles

## Soluciones Específicas

### Si el Dispositivo Expo No Puede Conectarse

1. **Verifica la URL en el código**:
   - La aplicación debe usar `http://192.168.100.129:5000` (o tu IP local)
   - NO debe usar `localhost` o `127.0.0.1`

2. **Prueba la conexión manualmente**:
   - En un navegador en tu dispositivo móvil, intenta acceder a:
   - `http://192.168.100.129:5000/status`
   - Deberías ver una respuesta JSON

3. **Verifica otros firewalls**:
   - Desactiva temporalmente cualquier antivirus o firewall adicional
   - Verifica que tu router no esté bloqueando las conexiones

### Si el Backend No Responde

1. **Verifica que el backend esté en ejecución**:
   - Deberías ver una ventana de comando con mensajes del servidor Python
   - Si no está en ejecución, ejecuta `start_expo.bat`

2. **Verifica los puertos**:
   - Asegúrate de que ninguna otra aplicación esté usando el puerto 5000
   - Puedes verificar con: `netstat -ano | findstr :5000`

## Comandos Útiles

- `start_expo.bat`: Inicia el backend optimizado para Expo
- `setup_firewall.bat`: Configura el firewall (ejecutar como administrador)
- `update_expo_config.js`: Actualiza la configuración para usar la IP correcta
- `test_expo_connection.js`: Prueba la conexión desde Expo al backend
- `fix_expo_connection.js`: Herramienta de diagnóstico completa
- `restart_expo_app.bat`: Reinicia todo el sistema

## Verificación Final

Para confirmar que todo está configurado correctamente:

1. El backend debe estar en ejecución
2. La regla del firewall debe estar configurada
3. La aplicación Expo debe usar la IP correcta (no localhost)
4. El dispositivo debe estar en la misma red WiFi

Si has seguido todos estos pasos y sigues teniendo problemas, es posible que haya alguna restricción adicional en tu red o dispositivo.

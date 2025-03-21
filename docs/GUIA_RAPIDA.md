# Guía Rápida para AstroBot Backend

Esta guía te ayudará a configurar y usar el backend de AstroBot de manera rápida y sencilla.

## Inicio Rápido

Para iniciar el backend y configurar todo automáticamente:

1. Ejecuta `start_simple.bat`
2. Espera a que el backend se inicie completamente
3. La aplicación en tu dispositivo se conectará automáticamente

## Conexión con Dispositivos

### Emuladores Android
- Se configuran automáticamente para usar `10.0.2.2:5000`
- No requieren configuración adicional

### Dispositivos Físicos
- Deben estar en la misma red WiFi que tu PC
- Ejecuta `setup_firewall.bat` como administrador para permitir conexiones
- La aplicación usará automáticamente la IP de tu PC

### Dispositivos Expo
- Para una configuración optimizada, usa `start_expo.bat`
- Si tienes problemas, consulta `SOLUCION_PROBLEMAS_EXPO.md`

## Solución de Problemas Comunes

### La aplicación no se conecta al backend

1. Verifica que el backend esté en ejecución
   - Deberías ver "Backend iniciado correctamente" en la terminal

2. Verifica la configuración del firewall
   - Ejecuta `setup_firewall.bat` como administrador

3. Verifica la conexión de red
   - El dispositivo debe estar en la misma red WiFi que tu PC
   - No debe haber restricciones en la red

4. Actualiza la configuración
   - Ejecuta `node update_universal_config.js`
   - Reinicia la aplicación en tu dispositivo

### Problemas con WSL

Si estás usando WSL y tienes problemas:

1. Ejecuta `start_expo_wsl.bat`
2. Consulta `CONEXION_WSL.md` para más detalles

## Pruebas de Conexión

Para verificar que todo funciona correctamente:

1. Ejecuta `node test_expo_connection.js`
2. Deberías ver mensajes de "Conexión exitosa"

## Documentación Adicional

- `CONFIGURACION.md`: Documentación detallada de todos los scripts
- `SOLUCION_PROBLEMAS_EXPO.md`: Guía para problemas con Expo
- `CONEXION_WSL.md`: Información sobre conexión a través de WSL

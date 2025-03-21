# Guía de Conexión para Dispositivos Expo

Esta guía te ayudará a resolver los problemas de conexión entre tu dispositivo Expo y el backend de AstroBot.

## Requisitos

- Backend de AstroBot en ejecución
- Dispositivo con Expo instalado
- Ambos dispositivos en la misma red WiFi

## Pasos para la Conexión

### 1. Iniciar el Backend para Expo

Usa el script `start_expo.bat` para iniciar el backend optimizado para dispositivos Expo:

```bash
.\start_expo.bat
```

Este script:
- Inicia el backend de Python
- Actualiza la configuración para usar la IP correcta
- Prueba la conexión

### 2. Configurar el Firewall

Es **CRÍTICO** configurar el firewall para permitir conexiones al puerto 5000:

1. Ejecuta `setup_firewall.bat` como administrador:
   - Haz clic derecho en el archivo
   - Selecciona "Ejecutar como administrador"

2. Verifica que la regla se haya creado correctamente:
   - Ejecuta `test_expo_connection.js` para verificar

### 3. Verificar la Conexión

Ejecuta el script de prueba para verificar que el backend sea accesible:

```bash
node test_expo_connection.js
```

Si la prueba es exitosa, verás un mensaje como:

```
✅ Conexión exitosa!
Tiempo de respuesta: 5ms
Estado del backend: {
  "message": "El servidor está en funcionamiento correctamente",
  "status": "ok",
  "version": "1.0.0"
}
```

### 4. Solución de Problemas Comunes

#### El dispositivo Expo no puede conectarse

1. **Verifica la Red WiFi**:
   - Asegúrate de que el dispositivo esté en la misma red WiFi que tu computadora
   - Verifica que no estés usando una red con restricciones (como redes corporativas)

2. **Verifica la IP**:
   - La aplicación debe usar la IP correcta de tu computadora (ej: `192.168.100.129`)
   - Ejecuta `update_expo_config.js` para actualizar la configuración

3. **Verifica el Firewall**:
   - Ejecuta `setup_firewall.bat` como administrador
   - Verifica que la regla "AstroBot Backend" se haya creado correctamente

4. **Reinicia la Aplicación Expo**:
   - Cierra completamente la aplicación Expo en tu dispositivo
   - Vuelve a abrirla y prueba la conexión

#### Timeout en la Conexión

Si recibes un error de timeout, verifica:

1. La regla del firewall está correctamente configurada
2. El backend está en ejecución
3. La IP configurada en la aplicación es correcta

## Comandos Útiles

- `start_expo.bat`: Inicia el backend optimizado para Expo
- `setup_firewall.bat`: Configura el firewall (ejecutar como administrador)
- `update_expo_config.js`: Actualiza la configuración para usar la IP correcta
- `test_expo_connection.js`: Prueba la conexión desde Expo al backend

## Verificación Final

Para confirmar que todo está configurado correctamente:

1. El backend debe estar en ejecución
2. La regla del firewall debe estar configurada
3. La aplicación Expo debe usar la IP correcta
4. El dispositivo debe estar en la misma red WiFi

Si sigues estos pasos, deberías poder conectarte correctamente desde tu dispositivo Expo al backend de AstroBot.

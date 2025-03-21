# Configuración de AstroBot Backend y Conexión con Dispositivos

Este documento explica cómo configurar y conectar el backend de AstroBot con diferentes dispositivos, incluyendo emuladores y dispositivos físicos.

## Estructura del Proyecto

El proyecto consta de dos partes principales:

- **Backend (Astroback)**: Servidor Flask que proporciona la API para AstroBot
- **Frontend (Astrolabx3/AstroLabCalculator)**: Aplicación React Native que se comunica con el backend

## Scripts Disponibles

### Scripts Principales

1. **start_simple.bat**
   - Inicia el backend de forma simple
   - Actualiza la configuración universal para todos los dispositivos
   - Ideal para uso general

2. **start_expo.bat**
   - Inicia el backend optimizado para dispositivos Expo
   - Actualiza la configuración específica para Expo
   - Prueba la conexión para dispositivos Expo

3. **start_expo_wsl.bat**
   - Inicia el backend usando la IP de WSL (172.18.112.1)
   - Útil cuando los dispositivos solo pueden conectarse a través de WSL

### Scripts de Configuración

1. **update_universal_config.js**
   - Detecta automáticamente la dirección IP local
   - Configura la aplicación para usar la IP correcta según el dispositivo:
     - Emuladores Android: 10.0.2.2:5000
     - Dispositivos físicos: [IP local]:5000
     - Web: localhost:5000

2. **update_expo_config.js**
   - Configura específicamente para dispositivos Expo
   - Usa la IP local para permitir conexiones desde dispositivos físicos

3. **update_wsl_config.js**
   - Configura para usar la IP de WSL (172.18.112.1)
   - Útil cuando WSL está manejando las conexiones

### Scripts de Prueba

1. **test_expo_connection.js**
   - Prueba la conexión desde dispositivos Expo al backend
   - Verifica diferentes URLs para asegurar la accesibilidad

2. **test_wsl_connection.js**
   - Prueba específicamente la conexión a través de la IP de WSL
   - Verifica que el backend sea accesible desde WSL

### Scripts de Utilidad

1. **setup_firewall.bat** (requiere permisos de administrador)
   - Configura el firewall de Windows para permitir conexiones al puerto 5000
   - Esencial para permitir que dispositivos externos se conecten al backend

2. **setup_firewall_visible.bat** (requiere permisos de administrador)
   - Versión más detallada del script de configuración del firewall
   - Muestra más información durante la ejecución

## Configuración del Firewall

Para que los dispositivos físicos puedan conectarse al backend, es necesario configurar el firewall de Windows:

1. Ejecuta **setup_firewall.bat** como administrador
2. Verifica que se haya creado la regla "AstroBot Backend"
3. Si hay problemas, ejecuta **setup_firewall_visible.bat** para ver más detalles

## Solución de Problemas

### Problemas de Conexión con Dispositivos Físicos

1. **Verificar la red**
   - Asegúrate de que el dispositivo esté en la misma red WiFi que tu PC
   - Verifica que no haya restricciones en la red

2. **Verificar el firewall**
   - Ejecuta `setup_firewall.bat` como administrador
   - Verifica que la regla "AstroBot Backend" exista

3. **Verificar la IP**
   - Ejecuta `node update_universal_config.js` para actualizar la configuración
   - Reinicia la aplicación en el dispositivo

### Problemas con WSL

Si estás usando WSL y tienes problemas de conexión:

1. Ejecuta `start_expo_wsl.bat` para usar la IP de WSL
2. Si los dispositivos no pueden conectarse a la IP de WSL, usa la IP de tu tarjeta de red física
3. Consulta el documento `CONEXION_WSL.md` para más detalles

## Documentación Adicional

- **SOLUCION_PROBLEMAS_EXPO.md**: Guía detallada para solucionar problemas de conexión con Expo
- **CONEXION_WSL.md**: Información específica sobre la conexión a través de WSL
- **GUIA_RAPIDA.md**: Instrucciones simplificadas para usar el backend

## Pruebas de Conexión

Para verificar que todo funciona correctamente:

1. Inicia el backend con `start_simple.bat` o `start_expo.bat`
2. Ejecuta `node test_expo_connection.js` para probar la conexión
3. Abre la aplicación en tu dispositivo y verifica que pueda conectarse al backend

Si ves mensajes de "Conexión exitosa", la configuración está correcta.

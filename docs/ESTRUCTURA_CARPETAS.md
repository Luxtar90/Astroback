# Reorganización de la Estructura de Carpetas

Este documento describe la reorganización de la estructura de carpetas del proyecto AstroBot para mejorar la organización y mantenibilidad del código.

## Estructura Anterior

Anteriormente, todos los archivos se encontraban en la carpeta raíz del proyecto, lo que dificultaba la navegación y el mantenimiento.

## Nueva Estructura

La nueva estructura organiza los archivos en carpetas temáticas:

```plaintext
AstroBot/
├── app/                  # Código principal de la aplicación
│   ├── __init__.py       # Inicialización de la aplicación Flask
│   ├── ai.py             # Funciones para interactuar con OpenRouter
│   ├── config.py         # Configuración de la aplicación
│   └── routes.py         # Definición de rutas y endpoints
├── docs/                 # Documentación del proyecto
│   ├── CONFIGURACION.md  # Guía de configuración
│   ├── DOCKER_PRODUCCION.md # Guía para despliegue con Docker
│   └── ...               # Otros documentos de ayuda
├── docker/               # Archivos relacionados con Docker
│   ├── docker-compose.yml # Configuración de servicios Docker
│   ├── Dockerfile        # Instrucciones para construir la imagen
│   ├── start_docker.bat  # Script para iniciar Docker
│   └── check_docker_status.bat # Script para verificar estado
├── scripts/              # Scripts de utilidad
│   ├── start_simple.bat  # Iniciar en modo simple
│   ├── start_expo.bat    # Iniciar para dispositivos Expo
│   └── ...               # Otros scripts de configuración
├── utils/                # Utilidades y herramientas
│   ├── update_universal_config.js # Actualizar configuración
│   ├── test_expo_connection.js    # Probar conexión Expo
│   └── ...               # Otras utilidades
```

## Nuevos Scripts de Acceso Rápido

Para mantener la compatibilidad con los flujos de trabajo existentes, se han creado scripts de acceso rápido en la carpeta raíz:

- `start.bat` - Inicia el backend en modo simple
- `start_expo.bat` - Inicia el backend para dispositivos Expo
- `start_docker.bat` - Inicia el backend con Docker

## Nuevos Scripts de Instalación Automática

Se han creado nuevos scripts para facilitar la instalación y configuración en nuevos sistemas:

- `instalar_y_ejecutar.bat` - Script completo que verifica requisitos, instala dependencias y ejecuta el backend
- `instalar_docker.bat` - Script para instalar y configurar Docker automáticamente

## Beneficios de la Nueva Estructura

1. **Mejor Organización**: Los archivos están agrupados por función, facilitando la navegación.
2. **Mantenibilidad Mejorada**: Es más fácil encontrar y modificar archivos relacionados.
3. **Escalabilidad**: La estructura facilita la adición de nuevas características sin crear desorden.
4. **Claridad**: La separación clara entre código, documentación, scripts y utilidades.
5. **Compatibilidad**: Los scripts de acceso rápido mantienen la compatibilidad con los flujos de trabajo existentes.

## Cómo Usar la Nueva Estructura

Para usuarios nuevos:

1. Ejecutar `instalar_y_ejecutar.bat` para una configuración completa
2. O ejecutar `instalar_docker.bat` para configurar con Docker

Para usuarios existentes:

1. Seguir usando los scripts de acceso rápido en la carpeta raíz
2. Referirse a la documentación en la carpeta `docs` para más información

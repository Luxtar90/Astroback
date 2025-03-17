# run.py
from app import create_app
from dotenv import load_dotenv

# Carga las variables de entorno definidas en el archivo .env
load_dotenv()

app = create_app()

if __name__ == '__main__':
    # Configurar host='0.0.0.0' permite que el servidor sea accesible 
    # desde cualquier dispositivo en la red, no solo desde localhost
    app.run(host='0.0.0.0', port=5000, debug=True)

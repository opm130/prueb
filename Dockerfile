# Usa una imagen base de Python
FROM python:3.9-slim

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de requirements y el código fuente al contenedor
COPY requirements.txt /app/

# Actualiza pip, instala las dependencias del sistema y los paquetes necesarios
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libglib2.0-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    git \
    && pip install --upgrade pip \
    && pip install -r requirements.txt

# Establece variables de entorno necesarias
ENV NIXPACKS_PATH=/opt/venv/bin:$NIXPACKS_PATH

# Crea un entorno virtual e instala las dependencias
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install -r requirements.txt

# Copia el código fuente al contenedor
COPY . /app/

# Establece el entorno virtual como la ruta de ejecución por defecto
ENV PATH="/opt/venv/bin:$PATH"

# Expone el puerto en el que la aplicación escuchará
EXPOSE 8000

# Comando para ejecutar la aplicación
CMD ["python", "app.py"]


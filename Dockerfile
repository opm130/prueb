# Usa una imagen base de Python
FROM python:3.9-slim

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo de requirements al contenedor
COPY requirements.txt /app/

# Instala las dependencias del sistema
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instala pip y actualiza
RUN pip install --upgrade pip

# Crea un entorno virtual y activa el entorno virtual e instala las dependencias
RUN python -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install -r requirements.txt

# Verificar las instalaciones
RUN . /opt/venv/bin/activate && pip list

# Copia el código fuente al contenedor
COPY . /app/

# Establece el entorno virtual como la ruta de ejecución por defecto
ENV PATH="/opt/venv/bin:$PATH"

# Expone el puerto en el que la aplicación escuchará
EXPOSE 8000

# Comando para ejecutar la aplicación
CMD ["python", "app.py"]

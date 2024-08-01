# Use the official Python image from the Docker Hub
FROM python:3.9-buster

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Update and upgrade the base image
RUN apt-get update && apt-get -y upgrade

# Install build dependencies and utilities
RUN apt-get install -y --no-install-recommends \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libglib2.0-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Compile and install GStreamer
RUN wget https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.18.4.tar.xz && \
    tar -xvf gstreamer-1.18.4.tar.xz && \
    cd gstreamer-1.18.4 && \
    ./configure && \
    make && \
    make install

# Copy the requirements file
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY . /app/

# Expose the port the app runs on
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]

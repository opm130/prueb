# Use the official Python image from the Docker Hub
FROM python:3.9-buster

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Update and upgrade the base image
RUN apt-get update && apt-get -y upgrade

# Install required libraries separately with debugging
RUN apt-get install -y --no-install-recommends libglib2.0-0 || { echo 'Failed to install libglib2.0-0' ; exit 1; }
RUN apt-get install -y --no-install-recommends libsm6 || { echo 'Failed to install libsm6' ; exit 1; }
RUN apt-get install -y --no-install-recommends libxext6 || { echo 'Failed to install libxext6' ; exit 1; }
RUN apt-get install -y --no-install-recommends libxrender-dev || { echo 'Failed to install libxrender-dev' ; exit 1; }
RUN apt-get install -y --no-install-recommends libgstreamer1.0-0 || { echo 'Failed to install libgstreamer1.0-0' ; exit 1; }
RUN apt-get install -y --no-install-recommends libgstreamer-plugins-base1.0-0 || { echo 'Failed to install libgstreamer-plugins-base1.0-0' ; exit 1; }
RUN apt-get install -y --no-install-recommends libgstreamer-plugins-good1.0-0 || { echo 'Failed to install libgstreamer-plugins-good1.0-0' ; exit 1; }

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

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

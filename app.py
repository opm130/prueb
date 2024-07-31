from flask import Flask, request, jsonify, send_file
from ultralytics import YOLO
import cv2
import numpy as np
import tempfile

app = Flask(__name__)

# Cargar el modelo YOLO
model = YOLO("best1.pt")

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({"error": "No file part"})
    
    file = request.files['image']
    if file.filename == '':
        return jsonify({"error": "No selected file"})
    
    # Leer la imagen
    img_bytes = file.read()
    img = np.frombuffer(img_bytes, np.uint8)
    frame = cv2.imdecode(img, cv2.IMREAD_COLOR)
    
    # Realizar predicción
    resultados = model.predict(frame, imgsz=640, conf=0.98)
    
    # Procesar resultados
    anotaciones = resultados[0].plot()
    
    # Guardar la imagen anotada en un archivo temporal
    temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.jpg')
    cv2.imwrite(temp_file.name, anotaciones)
    temp_file.seek(0)
    
    # Enviar la imagen anotada como respuesta
    return send_file(temp_file.name, mimetype='image/jpeg')

if __name__ == '__main__':
    app.run(debug=True)

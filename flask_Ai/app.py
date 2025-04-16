from flask import Flask, request, jsonify
import numpy as np
import cv2
import os
from multiprocessing import Value
from Config import Config
from chatbot import *
from insight_ai import *
import requests
from utils import process_image_for_prediction
from Config import PROCESSED_FOLDER
import cv2

app = Flask(__name__)
app.config.from_object(Config)

counter = Value('i', 0)
# -----------------------------------------------------------------------------------------------------------------------------
# Esp32-Cam Routes

@app.route('/upload', methods=['POST'])
def predict_from_camera():
    if 'imageFile' not in request.files:
        return jsonify({"error": "No image file provided"}), 400

    file = request.files['imageFile']
    nparr = np.frombuffer(file.read(), np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    if img is None:
        return jsonify({"error": "Failed to decode image"}), 422

    save_path = os.path.join(PROCESSED_FOLDER, "processed_image.jpg")
    cv2.imwrite(save_path, img)

    # If you want real prediction later, uncomment this:
    results = process_image_for_prediction(img)
    print("message Image processing in progress")
    return jsonify(results), 200

    #return jsonify({"message": "Image processing in progress"}), 202

# -----------------------------------------------------------------------------------------------------------------------------
# Chat-Bot

@app.route('/api/chat/init',methods=['POST'])
def init_chat():
	sensor_data = request.json
	if not sensor_data:
		return jsonify({"error": "Sensor data missing","Success":"False"}), 400

	init_chat_session(sensor_data)
	return jsonify({"message": "Chat session initialized.","Success":"True"}), 200

@app.route('/api/chat/ask',methods=['POST'])
def ask_bot():
    data = request.json
    if not data or 'user_input' not in data:
        return jsonify({"error": "User input missing","Success":"False"}), 400

    user_input = data['user_input']
    response = chat_with_bot(user_input)
    return jsonify({"response": response,"Success":"True"}), 200


@app.route('/api/chat/end', methods=['POST'])
def end_chat():
    end_chat_session()
    return jsonify({"message": "Chat session cleared.","Success":"True"}), 200


@app.route('/api/chat/sensor-data', methods=['GET', 'POST'])
def get_data():
    try:
        base_url = "http://localhost:5000/api/v1"
        endpoints = {
            "temperature": "/get-Temprature",
            "humidity": "/get-Humidity",
            "light": "/get-LDR",
            "soilMoisture": "/get-SoilMoisture",
            "plantHeight": "/get-IR1"
        }

        sensor_data = {}
        int_keys = {"temperature", "humidity", "soilMoisture"}

        for key, endpoint in endpoints.items():
            res = requests.get(f"{base_url}{endpoint}")
            if res.status_code == 200:
                value = res.json().get("value", "N/A")
                if key in int_keys:
                    try:
                        # Convert float string/float to int
                        sensor_data[key] = int(float(value))
                    except:
                        sensor_data[key] = "error"
                else:
                    sensor_data[key] = value
            else:
                sensor_data[key] = "error"

        sensor_data['health'] = "healthy"
        sensor_data['plant'] = "tomato"

        return jsonify(sensor_data), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

#---------------------------------------------------------------------------------------------------------------------------------
#Insight Ai

@app.route('/api/ai/insight', methods=['POST'])
def insight_ai():
    data = request.json
    print("Router debugging")
    print(data)  
    
    if not data or 'Sensor' not in data:
        return jsonify({"error": "Data missing", "Success": "False"}), 400

    sensor_data = data['Sensor']  # Extract sensor data from the 'Sensor' key
    insight = get_plant_insight(sensor_data)
    
    # Ensure the response is formatted as needed
    return jsonify({"response": insight, "Success": "True"}), 200

	


if __name__ == "__main__":
	app.run(host='0.0.0.0', port=5001, debug=True)
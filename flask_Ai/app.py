from flask import Flask, request, jsonify
import numpy as np
import cv2
import os
from multiprocessing import Value
from Config import Config
from chatbot import *
from insight_ai import *
app = Flask(__name__)
app.config.from_object(Config)

counter = Value('i', 0)
# -----------------------------------------------------------------------------------------------------------------------------
# Esp32-Cam Routes

def save_img(img):
	with counter.get_lock():
		counter.value += 1
		count = counter.value
	img_dir = "esp32_imgs"
	if not os.path.isdir(img_dir):
		os.mkdir(img_dir)
	img_name = f"img_{count}.jpg"
	cv2.imwrite(os.path.join(img_dir, img_name), img)
	return img_name

@app.route('/upload', methods=['POST'])
def upload():
	img = None
	if request.files:
		file = request.files['imageFile']
		nparr = np.frombuffer(file.read(), np.uint8)
		img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
		filename = save_img(img)
		
		return jsonify({
			"status": "success",
			"message": "Image received and saved",
			"filename": filename
		}), 201
	else:
		return jsonify({
			"status": "failure",
			"message": "No image received"
		}), 400

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
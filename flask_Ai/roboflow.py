import cv2
import requests

def send_to_roboflow(image, model_info):
    url = f"https://detect.roboflow.com/{model_info['model_id']}/{model_info['version']}"
    params = {"api_key": model_info['api_key']}
    _, buffer = cv2.imencode('.jpg', image)
    files = {"file": ("image.jpg", buffer.tobytes(), "image/jpeg")}
    response = requests.post(url, files=files, params=params)

    if response.status_code == 200:
        result = response.json()
        predicted_classes = result.get("predicted_classes", [])
        return predicted_classes[0] if predicted_classes else "Unknown"
    else:
        print(f"Roboflow error: {response.status_code} - {response.text}")
        return "Error"
import os
import cv2
from PIL import ImageEnhance
from Config import PROCESSED_FOLDER, MODEL_CONFIGS
from roboflow import send_to_roboflow

def process_image_for_prediction(image):
    if image is None:
        print("Error: Could not decode image.")
        return {}

    save_path = os.path.join(PROCESSED_FOLDER, "processed_image.jpg")
    cv2.imwrite(save_path, image)

    model_predictions = {}
    for model_key, config in MODEL_CONFIGS.items():
        prediction = send_to_roboflow(image, config)
        model_predictions[model_key] = prediction

    return model_predictions
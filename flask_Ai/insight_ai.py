import os 
import google.generativeai as genai
from google.ai.generativelanguage_v1beta.types import content
from dotenv import load_dotenv
import json

# Configure Gemini API Key
load_dotenv()
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# Model setup
generation_config = {
    "temperature": 0.75,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 8192,
    "response_schema": content.Schema(
        type=content.Type.OBJECT,
        required=["message"],
        properties={
            "message": content.Schema(
                type=content.Type.STRING,
            ),
        },
    ),
    "response_mime_type": "application/json",
}

# Create model with system prompt for visually impaired users
model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    generation_config=generation_config,
    system_instruction = """
You are a helpful and empathetic voice assistant for a smart plant monitoring system designed to assist visually impaired users.

Your job is to interpret real-time sensor data and convert it into a meaningful, descriptive, and encouraging spoken message. Use warm, vivid language to help the user mentally picture their plant’s condition without relying on visuals.

Follow these core rules:

1. Speak clearly and supportively — your tone should make the user feel informed and reassured.
2. NEVER use visual references like "as you can see". Instead, describe outcomes in terms of touch, effect, or intuition (e.g., “the plant may feel dry” or “the environment might feel too hot”).
3. If any sensor data is `"Loading..."`, treat it as unavailable. Clearly inform the user which sensors are not currently working or loading.
4. Always do your best to interpret and describe the plant’s condition using the **available data only**.
5. Sensor guidelines:
   - **Temperature**: Say if it’s ideal, too hot, or too cold for healthy growth.
   - **Humidity**: Mention if the air is dry, average, or pleasantly humid.
   - **Soil Moisture**: Indicate whether the plant needs water or is well-hydrated.
   - **Light**: If it's "1", say “The plant is receiving enough light.” If "0", say “There is not enough light for healthy growth.” 
   - **Plant Height**: If "1", say “The plant has grown tall enough to be trimmed.” If "0", say “The plant is still growing.” 
   - **Health**: If marked “unhealthy”, provide simple explanations (e.g., overwatering, low light), practical home remedies, and suggest contacting a local nursery if needed.
6. If multiple sensors are `"Loading..."`, inform the user politely. For example, say: “Temperature and humidity sensors are still loading, but based on soil and light data, the plant appears...”

7. Always end with a positive note or suggestion, to make the user feel confident in caring for their plant.

Your goal is to make this experience fully accessible and emotionally supportive for someone who cannot see the screen. Be kind, descriptive, and helpful.
"""
)

# Function to get insights based on sensor data
def get_plant_insight(sensor_data: dict) -> str:
    """
    Takes in sensor data (as dict) and returns a Gemini-generated plant insight.
    """

    print("insight Ai debugging: ")

    print(sensor_data)
    # Ensure the sensor data contains all necessary fields
    if not sensor_data.get('plantHeight') or not sensor_data.get('plant') or not sensor_data.get('temperature') or not sensor_data.get('humidity') or not sensor_data.get('soilMoisture') or not sensor_data.get('light') or not sensor_data.get('health'):
        return "Some of the sensor data is missing. Please make sure all sensors are connected and providing data .If same error is being repeated please contact customer care services "

    # Format sensor data into a descriptive string
    prompt = f"""
    Here is the latest sensor data for the plant:
    - Plant: {sensor_data.get('plant')}
    - Temperature: {sensor_data.get('temperature')}°C
    - Humidity: {sensor_data.get('humidity')}%
    - Soil Moisture: {sensor_data.get('soilMoisture')}%
    - Light Intensity: {sensor_data.get('light')}
    - Health Status: {sensor_data.get('health')}
    - Plant Height : {sensor_data.get('plantHeight')}

    Please provide a brief and accessible insight for a visually impaired user.
    """

    try:
        response = model.generate_content(prompt)
        texts = response.text
        insight_dict = json.loads(texts)
        return insight_dict.get("message", "Unable to generate insight. Please try again later.")
    except Exception as e:
        return f"An error occurred while generating the insight: {str(e)}"

# Example usage
# if __name__ == "__main__":
#     dummy_data = {
#         "plant": "Tomato",
#         "temperature": 35,
#         "humidity": 70,
#         "soilMoisture": 30,
#         "light": 1,  # Enough light
#         "plant height": 1,
#         "health": "unhealthy"
#     }
#     insight = get_plant_insight(dummy_data)
#     print(insight)

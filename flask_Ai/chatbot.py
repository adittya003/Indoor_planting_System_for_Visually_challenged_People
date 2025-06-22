# chatbot.py
import os
import google.generativeai as genai
from dotenv import load_dotenv

# Load environment
load_dotenv()
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# Global chat session
chat = None

model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    generation_config={
        "temperature": 0.75,
        "top_p": 0.95,
        "top_k": 40,
        "max_output_tokens": 8192,
    },
    system_instruction="""You are a helpful chatbot for a plant monitoring system used by visually impaired users.You should only
    answer queries related to plants and Indooring Gardening. Avoid Answering topics outside Plants and Indooring Gardening\n"""
)

def init_chat_session(sensor_data: dict):
    global chat
    print("\n[DEBUG] Inside init_chat_session")

    if not sensor_data.get('plantHeight') or not sensor_data.get('plant') or not sensor_data.get('temperature') or not sensor_data.get('humidity') or not sensor_data.get('soilMoisture') or not sensor_data.get('light') or not sensor_data.get('health'):
        print("[DEBUG] Some sensor values are missing!")
        return "Missing data"

    data_description = f"""
    Sensor Data:
    - Plant: {sensor_data.get('plant')}
    - Temperature: {sensor_data.get('temperature')}°C
    - Humidity: {sensor_data.get('humidity')}%
    - Soil Moisture: {sensor_data.get('soilMoisture')}%
    - Light Intensity: {sensor_data.get('light')}
    - Health Status: {sensor_data.get('health')}
    - Plant Height : {sensor_data.get('plantHeight')}
    """

    print("[DEBUG] Creating chat session with Gemini...")
    try:
        chat = model.start_chat(history=[
            {"role": "user", "parts": [data_description]}
        ])
        print("[DEBUG] Chat session created!")
    except Exception as e:
        print("[ERROR] Failed to create chat session:", e)



def chat_with_bot(user_input: str) -> str:
    global chat
    if chat is None:
        return "Chat session not initialized. Please initialize first via /api/chat/init."
    response = chat.send_message(user_input)
    return response.text


def end_chat_session():
    global chat
    chat = None


# if __name__ == "__main__":
#     dummy_sensor_data = {
#         "plant": "Tomato",
#         "temperature": 35,
#         "humidity": 70,
#         "soilMoisture": 30,
#         "light": 1,
#         "plantHeight": 1,
#         "health": "unhealthy"
#     }

#     print("\nInitializing chat session...\n")
#     init_chat_session(dummy_sensor_data)

#     while True:
#         user_input = input("You: ")
#         if user_input.lower() in ["exit", "quit", "bye"]:
#             print("Ending chat session.")
#             end_chat_session()
#             break

#         bot_reply = chat_with_bot(user_input)
#         print("Bot:", bot_reply)

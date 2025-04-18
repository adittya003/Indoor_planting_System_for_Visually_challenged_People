# Smart Plant Monitoring & Assistant App

## Overview
This project is a comprehensive Smart Plant Monitoring Android application designed with a strong focus on accessibility and user-friendly interaction. It integrates real-time sensor data, actionable insights powered by AI, a voice assistant, and a chatbot interface—all built to assist users, especially visually challenged individuals, in managing plant health efficiently. The backend is powered by Node.js and Flask, while the frontend is developed using Flutter.

## Key Features

### 1. **Human-Computer Interaction (HCI) for Accessibility**
- **Voice Feedback**: A central floating voice icon in the thumb zone is provided on the Plant Details screen. When tapped, the app reads out all the plant’s sensor data using Text-to-Speech (TTS), eliminating the need for visual interaction.
- **Vibration Feedback**: To enhance tactile feedback for visually challenged users, button interactions provide vibration confirmation.
- **Gesture-Based Navigation**: Users can navigate between key screens using swipe gestures:
  - Swipe Left: Navigate to the chatbot interface.
  - Swipe Right: Return to the plant details page.
- **Voice-enabled Chatbot**: Accessible by swiping, the chatbot allows users to speak queries. The speech is transcribed to text, processed by a Gemini API-powered chatbot, and responses are read out loud.

### 2. **Sensor Data Dashboard**
The Plant Details page displays live sensor readings including:
- Soil Moisture
- Temperature
- Humidity
- LDR (light intensity)
- Plant Height
- Intruder Detection
- Water Level

Data is fetched from a Node.js backend via RESTful APIs, and real-time updates (like intruder and water level) are handled using WebSocket.

### 3. **Water Pump Control**
Users can activate the water pump remotely via a button. The backend API triggers the ESP32 to switch on the pump for 5 seconds.

### 4. **AI Insight Generator**
- A Gemini-powered AI insight module processes the raw sensor values to provide actionable suggestions.
- Instead of displaying raw temperature or moisture data, users hear messages like: "Soil moisture is too low, consider watering the plant."
- This makes the information more interpretable for non-experts.

### 5. **Chatbot Interface**
- The chatbot is accessible via swipe gestures and allows voice or text input.
- It provides AI-generated responses to user queries about the plant’s condition.
- It retains conversation history during a session, but resets once the user exits the chatbot screen.

### 6. **Image-Based Plant Analysis**
- **Health Classification**: A Vision Transformer (ViT) model is used to classify the plant as healthy or unhealthy.
- **Fruit Detection**: A YOLOv11 model is used to detect tomatoes in the captured image.
- **Architecture**:
  - ESP32-CAM captures images every 48 hours and uploads them to a cloud storage.
  - The Flask backend retrieves the image and passes it to the ML models.
  - Results are fed back into the app and displayed on the Plant Details page.

## Tech Stack

### Frontend:
- **Flutter** (Android App)
  - Text-to-Speech
  - Gesture Detection
  - UI Accessibility Support

### Backend:
- **Node.js** (Sensor APIs, SocketIO)
- **Flask** (AI Image Analysis & Insight Generation)

### Machine Learning:
- **Vision Transformer (ViT)**: Plant health classification
- **YOLOv11**: Tomato detection in plant images
- **Gemini API**: For chatbot and natural language insights

### Hardware:
- **ESP32-CAM**: Image capture
- **Soil & Weather Sensors**: Soil Moisture, Temperature, Humidity, Light, Intruder IR, Water Level

## Folder Structure
```
PlantAssistantApp/
├── backend_nodejs/
├── backend_flask/
├── Flutter/
│   ├── lib/
│   │   ├── login.dart
│   │   ├── plant_details.dart
│   │   ├── chatbot.dart
│   │   ├── danger.dart
│   │   └── ...
├── assets/
│   └── Images/
│       └── Plant_view_page.jpg
├── README.md
```

## Getting Started

### 1. Run the Node.js Server:
```
cd backend_nodejs
npm install
node app.js
```

### 2. Run the Flask Server:
```
cd backend_flask
pip install -r requirements.txt
python app.py
```

### 3. Run the Flutter App:
```
cd Flutter
flutter pub get
flutter run
```

> Note: Ensure Android Emulator is set up or a real device is connected for full functionality.

## Conclusion
This application demonstrates a powerful blend of hardware, software, and AI, built with an empathetic approach toward accessibility. Its voice-first interaction design, gesture controls, and intelligent AI feedback mechanisms make it a highly user-centric solution tailored for visually challenged individuals who wish to monitor and nurture their plants with ease.

---

Crafted with care by Adittya Narayan, VIT 2025


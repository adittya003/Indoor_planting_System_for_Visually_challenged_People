#define BLYNK_TEMPLATE_ID "TMPL3PY7mUl0E"
#define BLYNK_TEMPLATE_NAME "Indoor Gardening System"
#define BLYNK_AUTH_TOKEN "Ye6aLD7SHBPAxA0dhu7A2vnxLzjKU1sm"

#include <WiFi.h>
#include <BlynkSimpleEsp32.h>
#include "DHT.h"

// Define sensor pins
#define DHT_PIN 25           // Analog
#define WATER_LEVEL_PIN 35   // Analog
#define IR_SENSOR_1 27       // Digital
#define IR_SENSOR_2 26       // Digital
#define SOIL_MOISTURE_PIN 34 // Analog
#define LDR_PIN 33           // Digital 
#define RELAY_PIN 32         // Analog

// WiFi Credentials
char ssid[] = "Galaxy A55 5G 3E1B";
char pass[] = "aditigreat";

// DHT Setup
#define DHTTYPE DHT11
DHT dht(DHT_PIN, DHTTYPE);

// Pump Control Variables
bool manualPumpControl = false;  // 1 = manual ON, 0 = manual OFF
bool useManualControl = false;   // If true, override auto logic

// Blynk handler for pump manual control (V8)
BLYNK_WRITE(V8) {
  int pinValue = param.asInt();
  if (pinValue == 1) {
    useManualControl = true;
    manualPumpControl = true;
    Serial.println("Manual Pump Control: ON");
  } else if (pinValue == 0) {
    useManualControl = true;
    manualPumpControl = false;
    Serial.println("Manual Pump Control: OFF");
  }
}

void setup() {
  Serial.begin(115200);

  // Initialize sensors
  dht.begin();
  pinMode(IR_SENSOR_1, INPUT);
  pinMode(IR_SENSOR_2, INPUT);
  pinMode(LDR_PIN, INPUT);

  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, HIGH);  // Pump OFF initially

  // Initialize Blynk
  Blynk.begin(BLYNK_AUTH_TOKEN, ssid, pass);
}

void loop() {
  Blynk.run();

  // Read DHT Sensor
  float temperature = dht.readTemperature() + 24;
  float humidity = dht.readHumidity() + 30;

  // Read Water Level Sensor
  int waterLevel = analogRead(WATER_LEVEL_PIN);

  // Read IR Sensors
  int ir1 = digitalRead(IR_SENSOR_1);
  int ir2 = digitalRead(IR_SENSOR_2);

  // Read Soil Moisture Sensor
  int soilMoisture = analogRead(SOIL_MOISTURE_PIN);

  // Read LDR Sensor (Light State)
  int ldrValue = digitalRead(LDR_PIN);
  int lightState = ldrValue == LOW ? 1 : 0;

  // Print values to Serial Monitor
  Serial.println("-----------------------------");
  Serial.print("Temperature: "); Serial.print(temperature); Serial.println(" °C");
  Serial.print("Humidity: "); Serial.print(humidity); Serial.println(" %");
  Serial.print("Water Level: "); Serial.println(waterLevel);
  Serial.print("IR Sensor 1: "); Serial.println(ir1 == LOW ? "Object Detected" : "No Object");
  Serial.print("IR Sensor 2: "); Serial.println(ir2 == LOW ? "Object Detected" : "No Object");
  Serial.print("Soil Moisture: "); Serial.println(soilMoisture);
  Serial.print("Light State: "); Serial.println(lightState == 0 ? "Dark" : "Bright");

  // Pump Control
  if (useManualControl) {
    digitalWrite(RELAY_PIN, manualPumpControl ? LOW : HIGH);  // Active LOW
    Serial.println(manualPumpControl ? "Manual: Turning pump ON" : "Manual: Turning pump OFF");
  } else {
    if (soilMoisture > 2500) {
      Serial.println("Auto: Soil is dry. Turning pump ON");
      digitalWrite(RELAY_PIN, LOW); // Active LOW
    } else {
      Serial.println("Auto: Soil is wet. Turning pump OFF");
      digitalWrite(RELAY_PIN, HIGH);
    }
  }

  // Upload data to Blynk
  Blynk.virtualWrite(V1, humidity);
  Blynk.virtualWrite(V2, temperature);
  Blynk.virtualWrite(V3, lightState);
  Blynk.virtualWrite(V4, waterLevel);
  Blynk.virtualWrite(V5, ir1);
  Blynk.virtualWrite(V6, ir2);
  Blynk.virtualWrite(V7, soilMoisture);

  Serial.println("-----------------------------");
  delay(5000);
}

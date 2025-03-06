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

// WiFi Credentials
char ssid[] = "Galaxy A55 5G 3E1B";
char pass[] = "aditigreat";

// DHT Setup
#define DHTTYPE DHT11
DHT dht(DHT_PIN, DHTTYPE);

void setup() {
  Serial.begin(115200);

  // Initialize sensors
  dht.begin();
  pinMode(IR_SENSOR_1, INPUT);
  pinMode(IR_SENSOR_2, INPUT);
  pinMode(LDR_PIN, INPUT);

  // Initialize Blynk
  Blynk.begin(BLYNK_AUTH_TOKEN, ssid, pass);
}

void loop() {
  Blynk.run();

  // Read DHT Sensor
  float temperature = dht.readTemperature()+30;
  float humidity = dht.readHumidity()+30;

  // Read Water Level Sensor
  int waterLevel = analogRead(WATER_LEVEL_PIN);

  // Read IR Sensors
  int ir1 = digitalRead(IR_SENSOR_1);
  int ir2 = digitalRead(IR_SENSOR_2);

  // Read Soil Moisture Sensor
  int soilMoisture = analogRead(SOIL_MOISTURE_PIN);

  // Read LDR Sensor (Light State)
  int ldrValue = digitalRead(LDR_PIN);
  int lightState = ldrValue == LOW ? 0 : 1;

  // Print values to Serial Monitor
  Serial.println("-----------------------------");
  Serial.print("Temperature: "); Serial.print(temperature); Serial.println(" °C");
  Serial.print("Humidity: "); Serial.print(humidity); Serial.println(" %");
  Serial.print("Water Level: "); Serial.println(waterLevel);
  Serial.print("IR Sensor 1: "); Serial.println(ir1 == LOW ? "Object Detected" : "No Object");
  Serial.print("IR Sensor 2: "); Serial.println(ir2 == LOW ? "Object Detected" : "No Object");
  Serial.print("Soil Moisture: "); Serial.println(soilMoisture);
  Serial.print("Light State: "); Serial.println(lightState == 0 ? "Dark" : "Bright");
  Serial.println("-----------------------------");

  // Upload data to Blynk
  Blynk.virtualWrite(V1, humidity);           // Humidity
  Blynk.virtualWrite(V2, temperature);        // Temperature
  Blynk.virtualWrite(V3, lightState);          // Light State
  Blynk.virtualWrite(V4, waterLevel);          // Water Level
  Blynk.virtualWrite(V5, ir1);                 // IR Sensor 1
  Blynk.virtualWrite(V6, ir2);                 // IR Sensor 2
  Blynk.virtualWrite(V7, soilMoisture);        // Soil Moisture

  delay(5000); // Delay before next reading
}

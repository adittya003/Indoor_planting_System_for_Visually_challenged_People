import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../tts_voice.dart';

class PlantDetailsPage extends StatefulWidget {
  @override
  _PlantDetailsPageState createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  late io.Socket socket;
  String intruderStatus = "Loading...";
  String waterLevel = "Loading...";
  bool isWatering = false; // State to track water button availability

  Map<String, String> sensorData = {
    'Soil Moisture': 'Loading...',
    'Temperature': 'Loading...',
    'Humidity': 'Loading...',
    'LDR': 'Loading...',
    'Plant Height': 'Loading...',
    'Plant Disease': 'Loading...',
    'Fruit Detection': 'Loading...',
  };

  @override
  void initState() {
    super.initState();
    setupWebSocket();
    fetchSensorData();
  }

  void setupWebSocket() {
    socket = io.io('ws://10.0.2.2:5000',
        io.OptionBuilder().setTransports(['websocket']).build());

    socket.on('sensorData', (data) {
      setState(() {
        intruderStatus = data['intruderStatus'];
        waterLevel = "${data['waterLevel']}%";
      });
    });
  }

  Future<void> fetchSensorData() async {
    Map<String, String> endpoints = {
      'Soil Moisture': 'get-SoilMoisture',
      'Temperature': 'get-Temprature',
      'Humidity': 'get-Humidity',
      'LDR': 'get-LDR',
      'Plant Height': 'get-IR1',
      'Plant Disease': '', // Temporary placeholder
      'Fruit Detection': '', // Temporary placeholder
    };

    for (var entry in endpoints.entries) {
      if (entry.value.isEmpty) {
        setState(() {
          sensorData[entry.key] = "Not Available";
        });
        continue;
      }

      try {
        final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/v1/${entry.value}'));
        final data = json.decode(response.body);

        setState(() {
          if (data['success']) {
            sensorData[entry.key] = "${data['value']}";
          } else {
            sensorData[entry.key] = "Error: ${data['message']}";
          }
        });
      } catch (e) {
        setState(() {
          sensorData[entry.key] = "Network Error";
        });
      }
    }
  }
  void speakPlantData(Map<String, String> sensorData){
    String speechText = "Plant status report: ";
    sensorData.forEach((key,value){
      speechText+="$key is value $value. ";
    });
    speechText+="Thank You !";

    TTSVoice().speak(speechText);
  }

  Future<void> waterPlant() async {
    if (isWatering) return; // Prevent multiple presses
    setState(() {
      isWatering = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/v1/waterpump-button'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Water pump activated for 5 seconds!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${data['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error. Try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network Error: Unable to reach the server.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    await Future.delayed(Duration(seconds: 5)); // Wait for 5 sec before re-enabling button
    setState(() {
      isWatering = false;
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant 1'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Images/Plant_view_page.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.56,
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  sensorBox('Soil Moisture', sensorData['Soil Moisture']!),
                  sensorBox('Temperature', sensorData['Temperature']!),
                  sensorBox('Humidity', sensorData['Humidity']!),
                  sensorBox('LDR', sensorData['LDR']!),
                  sensorBox('Plant Height', sensorData['Plant Height']!),
                  sensorBox('Water Level', waterLevel),
                  sensorBox('Plant Disease', sensorData['Plant Disease']!),
                  sensorBox('Fruit Detection', sensorData['Fruit Detection']!),
                  sensorBox('Intruder Status', intruderStatus),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SizedBox(
              width: 175,
              height: 175,
              child: FloatingActionButton(
                heroTag: "waterBtn",
                backgroundColor: isWatering ? Colors.grey : Colors.blue,
                shape: CircleBorder(),
                onPressed: isWatering ? null : waterPlant,
                child: Icon(Icons.water_drop, size: 100),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: MediaQuery.of(context).size.width * 0.05,
            child: SizedBox(
              width: 175,
              height: 175,
              child: FloatingActionButton(
                heroTag: "speakerBtn",
                backgroundColor: Colors.orange,
                shape: CircleBorder(),
                onPressed: () {
                  speakPlantData(sensorData);
                },
                child: Icon(Icons.volume_up, size: 100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sensorBox(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

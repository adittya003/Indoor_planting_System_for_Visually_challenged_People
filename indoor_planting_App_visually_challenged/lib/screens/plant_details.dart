import 'package:flutter/material.dart';

class PlantDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant 1'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Images/Plant_view_page.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main Container
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
                  sensorBox('Soil Moisture', '45%'),
                  sensorBox('Temperature', '30°C'),
                  sensorBox('Humidity', '60%'),
                  sensorBox('LDR', '700 lx'),
                  sensorBox('Plant Height', 'No'),
                  sensorBox('Water Level', '70%'),
                  sensorBox('Plant Disease', 'Yes'),
                  sensorBox('Fruit Detection', 'Yes'),
                ],
              ),
            ),
          ),

          // Watering Plant Button (Left-Centered, Bigger Size)
          Positioned(
            bottom: 80,
            left: MediaQuery.of(context).size.width * 0.05, // Adjust for center alignment
            child: SizedBox(
              width: 175, // Increased size
              height: 175,
              child: FloatingActionButton(
                heroTag: "waterBtn",
                backgroundColor: Colors.blue,
                shape: CircleBorder(),
                onPressed: () {
                  // Add functionality to water the plant
                },
                child: Icon(Icons.water_drop, size: 100), // Bigger Icon
              ),
            ),
          ),

          // Speaker Button (Right-Centered, Bigger Size)
          Positioned(
            bottom: 80,
            right: MediaQuery.of(context).size.width * 0.05, // Adjust for center alignment
            child: SizedBox(
              width: 175, // Increased size
              height: 175,
              child: FloatingActionButton(
                heroTag: "speakerBtn",
                backgroundColor: Colors.orange,
                shape: CircleBorder(),
                onPressed: () {
                  // Add functionality for voice output
                },
                child: Icon(Icons.volume_up, size: 100), // Bigger Icon
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sensor Box Widget
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
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

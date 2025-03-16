import 'package:flutter/material.dart';

class DangerAlertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900, // Danger background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Warning Icon
          Icon(
            Icons.warning,
            size: 100,
            color: Colors.yellow,
          ),
          SizedBox(height: 20),
          // Alert Message Box
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Danger Alert!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'An unusual activity has been detected in the farmland. Please check immediately.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Acknowledge Button
              FloatingActionButton(
                heroTag: "acknowledgeBtn",
                backgroundColor: Colors.green,
                shape: CircleBorder(),
                onPressed: () {
                  Navigator.pop(context); // Close alert
                },
                child: Icon(Icons.check, size: 40),
              ),
              SizedBox(width: 40),
              // Speaker Button (Voice Alert Placeholder)
              FloatingActionButton(
                heroTag: "speakerBtn",
                backgroundColor: Colors.orange,
                shape: CircleBorder(),
                onPressed: () {
                  // Voice alert feature to be integrated with backend
                },
                child: Icon(Icons.volume_up, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

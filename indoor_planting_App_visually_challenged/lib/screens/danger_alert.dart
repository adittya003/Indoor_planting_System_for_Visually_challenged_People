import 'package:flutter/material.dart';

class DangerAlertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900, // Danger background
      body: Stack(
        children: [
          // Warning Icon Positioned at the Top
          Positioned(
            top: 80, // Adjusted to move higher
            left: MediaQuery.of(context).size.width * 0.5 - 125, // Centered
            child: Icon(
              Icons.warning,
              size: 250,
              color: Colors.yellow,
            ),
          ),

          // Alert Message Box Positioned Below the Icon
          Positioned(
            top: 350, // Adjusted lower
            left: MediaQuery.of(context).size.width * 0.05,
            child: Container(
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade900,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'An unusual activity has been detected. Please check immediately.',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Acknowledge Button (Left Side, Bigger Size)
          Positioned(
            bottom: 110,
            left: MediaQuery.of(context).size.width * 0.05, // Adjust for alignment
            child: SizedBox(
              width: 175, // Increased size
              height: 175,
              child: FloatingActionButton(
                heroTag: "acknowledgeBtn",
                backgroundColor: Colors.green,
                shape: CircleBorder(),
                onPressed: () {
                  Navigator.pop(context); // Close alert
                },
                child: Icon(Icons.check, size: 100), // Bigger Icon
              ),
            ),
          ),

          // Speaker Button (Right Side, Bigger Size)
          Positioned(
            bottom: 110,
            right: MediaQuery.of(context).size.width * 0.05, // Adjust for alignment
            child: SizedBox(
              width: 175, // Increased size
              height: 175,
              child: FloatingActionButton(
                heroTag: "speakerBtn",
                backgroundColor: Colors.orange,
                shape: CircleBorder(),
                onPressed: () {
                  // Voice alert feature to be integrated with backend
                },
                child: Icon(Icons.volume_up, size: 100), // Bigger Icon
              ),
            ),
          ),
        ],
      ),
    );
  }
}

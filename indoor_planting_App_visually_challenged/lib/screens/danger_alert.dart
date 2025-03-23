import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../tts_voice.dart';
import 'plant_details.dart'; // Import Plant Details Page

class DangerAlertPage extends StatefulWidget {
  @override
  _DangerAlertPageState createState() => _DangerAlertPageState();
}

class _DangerAlertPageState extends State<DangerAlertPage> {
  late AudioPlayer _audioPlayer;
  bool isAcknowledged = false; // Track button presses

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playAlarm(); // Start alarm when page loads
  }

  // Play alarm in an infinite loop
  void _playAlarm() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Keep looping
    await _audioPlayer.play(AssetSource('sounds/alarm.mp3')); // Ensure path is correct
  }

  // Stop alarm and navigate if needed
  void _handleAcknowledge() async {
    if (!isAcknowledged) {
      await _audioPlayer.stop(); // Stop alarm
      setState(() {
        isAcknowledged = true; // First press
      });
    } else {
      await _audioPlayer.dispose(); // Clean up before navigation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PlantDetailsPage()),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Clean up audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900, // Danger background
      body: Stack(
        children: [
          // Warning Icon Positioned at the Top
          Positioned(
            top: 80,
            left: MediaQuery.of(context).size.width * 0.5 - 125,
            child: Icon(Icons.warning, size: 250, color: Colors.yellow),
          ),

          // Alert Message Box
          Positioned(
            top: 350,
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

          // Acknowledge Button
          Positioned(
            bottom: 110,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SizedBox(
              width: 175,
              height: 175,
              child: FloatingActionButton(
                heroTag: "acknowledgeBtn",
                backgroundColor: Colors.green,
                shape: CircleBorder(),
                onPressed: _handleAcknowledge,
                child: Icon(Icons.check, size: 100),
              ),
            ),
          ),

          // Speaker Button (Optional)
          Positioned(
            bottom: 110,
            right: MediaQuery.of(context).size.width * 0.05,
            child: SizedBox(
              width: 175,
              height: 175,
              child: FloatingActionButton(
                heroTag: "speakerBtn",
                backgroundColor: Colors.orange,
                shape: CircleBorder(),
                onPressed: () {
                  String DangerText = "An unusual activity has been detected. Possible Intruder. Please check immediately";
                  TTSVoice().speak(DangerText);
                },
                child: Icon(Icons.volume_up, size: 100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

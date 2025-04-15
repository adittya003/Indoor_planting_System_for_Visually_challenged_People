import 'package:flutter/material.dart';
import 'screens/chatbot.dart';
import 'screens/plant_details.dart';
import 'screens/danger_diseases.dart';
import 'screens/danger_alert.dart';
import 'screens/danger_waterlvl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // '/': (context) => LoginPage(),
        '/': (context) => PlantDetailsPage(),
        '/danger': (context) => DangerAlertPage(),
        '/disease': (context) => DangerDiseasesPage(),
        '/chatbot' : (context) => ChatBotPage(),
        '/waterLvl' : (context) => WaterDangerAlertPage()
      },
    );
  }
}

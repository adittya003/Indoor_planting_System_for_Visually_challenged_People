import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/plant_details.dart';
import 'screens/danger_alert.dart';
import 'screens/danger_diseases.dart';

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
        // '/plant': (context) => PlantDetailsPage(),
        '/': (context) => DangerAlertPage(),
        // '/disease': (context) => DangerDiseasesPage(),
      },
    );
  }
}

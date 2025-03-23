import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'plant_details.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  // Function to handle login request
  Future<void> login(BuildContext context, String blynkToken) async {
    final Uri apiUrl = Uri.parse('http://10.0.2.2:5000/api/auth/login'); // Update to use emulator IP

    try {
      // Sending a POST request with the blynkToken in the body
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'blynkToken': blynkToken}),
      );

      if (response.statusCode == 200) {
        // Parse the response if successful
        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];
        String token = responseData['token'];
        print("Login successful: $message");
        print("Received Token: $token");

        // Navigate to PlantDetailsPage after successful login
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailsPage(),
          ),
        );
      } else {
        // If the response is not 200, show an error message
        print("Failed to login: ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Images/Login_page.jpg"), // Background image
                fit: BoxFit.cover, // Cover entire screen
              ),
            ),
          ),

          // App Title (Centered at the Top)
          Positioned(
            top: 60, // Position at the top
            child: Text(
              "Plant Monitoring App",
              style: TextStyle(
                fontSize: 30, // Increased size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.black, // Black text
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.grey.shade600, // Shadow effect for depth
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),

          // Circular Login Form (Remains in Center)
          Center(
            child: Container(
              width: 350,
              height: 400,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                shape: BoxShape.circle, // Circular shape
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Shadow effect
                    blurRadius: 20,
                    spreadRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center, // Center elements
                crossAxisAlignment: CrossAxisAlignment.center, // Center text alignment
                children: [
                  Text(
                    "Login/Blynk_Token",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _controller, // Link the controller to the TextField
                    decoration: InputDecoration(
                      labelText: "Enter Code",
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                        borderSide: BorderSide(
                          color: Colors.black, // Border color
                          width: 2.5, // Increased thickness
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black, // Border color when not focused
                          width: 2.5, // Increased thickness
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blue, // Border color when focused
                          width: 3, // Increased thickness when focused
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 200, // Increased button width
                    child: ElevatedButton(
                      onPressed: () {
                        // Get the token from the text field
                        String blynkToken = _controller.text.trim();
                        // Call the login function and pass the context
                        login(context, blynkToken);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF81F0FC), // Button color
                        foregroundColor: Colors.black, // Text color
                        padding: EdgeInsets.symmetric(vertical: 10), // Taller button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 22, // Increased font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

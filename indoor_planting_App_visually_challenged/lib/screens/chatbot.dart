import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'plant_details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List<Map<String, String>> chatHistory = [];
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool isListening = false;
  bool isEmulator = false; // Set true for emulator

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    initChatSession(); // Initialize chat session with sensor data
  }

  @override
  void dispose() {
    endChatSession(); // Clear session on exit
    super.dispose();
  }

  Future<void> initChatSession() async {
    try {
      final sensorRes = await http.get(Uri.parse('http://10.0.2.2:5001/api/chat/sensor-data'));
      if (sensorRes.statusCode == 200) {
        final sensorData = json.decode(sensorRes.body);
        print(sensorData);
        await http.post(
          Uri.parse('http://10.0.2.2:5001/api/chat/init'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(sensorData),
        );
      } else {
        print("Failed to fetch sensor data");
      }
    } catch (e) {
      print("Error initializing chat: $e");
    }
  }

  Future<void> endChatSession() async {
    try {
      await http.post(Uri.parse('http://10.0.2.2:5001/api/chat/end'));
    } catch (e) {
      print("Error ending chat: $e");
    }
  }

  void sendMessage(String message) async {
    setState(() {
      chatHistory.add({'role': 'user', 'message': message});
    });

    String botResponse = await getGeminiResponse(message);

    setState(() {
      chatHistory.add({'role': 'bot', 'message': botResponse});
    });
  }

  Future<String> getGeminiResponse(String query) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/api/chat/ask'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_input': query}),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body['response'] ?? 'No reply from bot';
      } else {
        return 'Failed to get response: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  void listen() async {
    if (!isListening && !isEmulator) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('Status: $val'),
        onError: (val) => print('Error: $val'),
      );
      if (available) {
        setState(() => isListening = true);
        _speech.listen(
          onResult: (val) {
            if (val.finalResult) {
              setState(() => isListening = false);
              sendMessage(val.recognizedWords);
            }
          },
        );
      }
    } else if (isEmulator) {
      setState(() {
        isListening = false;
      });
    } else {
      setState(() => isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PlantDetailsPage()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Plant Chatbot")),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      final entry = chatHistory[index];
                      return Align(
                        alignment: entry['role'] == 'user'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: entry['role'] == 'user'
                                ? Colors.green[100]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(entry['message'] ?? ''),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "Ask your plant...",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          final msg = _controller.text.trim();
                          if (msg.isNotEmpty) {
                            sendMessage(msg);
                            _controller.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Mic Button - Disabled on Emulator
            if (!isEmulator)
              Positioned(
                bottom: 130,
                left: 0,
                right: 0,
                child: Center(
                  child: Opacity(
                    opacity: 0.4,
                    child: Transform.scale(
                      scale: 3,
                      child: FloatingActionButton(
                        heroTag: "mic",
                        backgroundColor: Colors.green,
                        child: Icon(
                          isListening ? Icons.mic : Icons.mic_none,
                          size: 40,
                        ),
                        onPressed: listen,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'plant_details.dart'; // Import your PlantDetailsPage

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

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void sendMessage(String message) async {
    setState(() {
      chatHistory.add({'role': 'user', 'message': message});
    });

    // TODO: Replace with actual API call
    String botResponse = await getGeminiResponse(message);

    setState(() {
      chatHistory.add({'role': 'bot', 'message': botResponse});
    });
  }

  Future<String> getGeminiResponse(String query) async {
    await Future.delayed(Duration(seconds: 1));
    return "This is a Gemini reply for: $query";
  }

  void listen() async {
    if (!isListening) {
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
          // Swipe up detected, navigate to PlantDetailsPage
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
            // Mic Button - Bigger, Transparent, Bottom Center
            Positioned(
              bottom: 130,
              left: 0,
              right: 0,
              child: Center(
                child: Opacity(
                  opacity: 0.4,
                  child: Transform.scale(
                    scale: 3, // Makes the mic button bigger
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isStringToBinary = true; // Toggle state
  String input = "";
  String result = "";

  // Converts string to binary (7-bit ASCII)
  String toSevenBitAscii(String input) {
    return input.runes
        .map((rune) {
      int asciiValue = rune & 0x7F; // Mask to get 7-bit ASCII
      return asciiValue.toRadixString(2).padLeft(7, '0');
    })
        .join(' ');
  }

  // Converts binary to string
  String fromSevenBitAscii(String binaryInput) {
    return binaryInput
        .split(' ')
        .map((binary) {
      int asciiValue = int.parse(binary, radix: 2);
      return String.fromCharCode(asciiValue);
    })
        .join('');
  }

  void showInputDialog() {
    TextEditingController inputController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isStringToBinary ? "Enter String" : "Enter Binary"),
          content: TextField(
            controller: inputController,
            decoration: InputDecoration(
                hintText: isStringToBinary ? "String" : "Binary"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  input = inputController.text;
                  result = isStringToBinary
                      ? toSevenBitAscii(input)
                      : fromSevenBitAscii(input);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("String and Binary Converter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Mode: "),
                Text(isStringToBinary ? "String to Binary" : "Binary to String"),
                Switch(
                  value: isStringToBinary,
                  onChanged: (value) {
                    setState(() {
                      isStringToBinary = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: showInputDialog,
              child: const Text("Enter Input"),
            ),
            const SizedBox(height: 20),
            if (result.isNotEmpty) ...[
              const Text(
                "Result:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SelectableText(
                result,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: result));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Result copied to clipboard!")),
                  );
                },
                child: const Text("Copy to Clipboard"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shop/utils/text_to_speech_helper.dart';

class TTSButton extends StatefulWidget {
  @override
  _TTSButtonState createState() => _TTSButtonState();
}

class _TTSButtonState extends State<TTSButton> {
  final TextToSpeechHelper ttsService = TextToSpeechHelper();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TTS Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter word',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final inputText = _textController.text;
                if (inputText.isNotEmpty) {
                  ttsService.tellWhatIsInThePicture(inputText);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter text before playing.')),
                  );
                }
              },
              child: Text('Play Message'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    ttsService.stop();
    super.dispose();
  }
}
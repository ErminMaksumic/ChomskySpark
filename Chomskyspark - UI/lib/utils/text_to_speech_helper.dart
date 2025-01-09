import 'package:flutter_tts/flutter_tts.dart';
import 'package:shop/models/user_language.dart';
import 'package:shop/utils/auth_helper.dart';

class TextToSpeechHelper {
  final FlutterTts _flutterTts = FlutterTts();
  List<UserLanguage>? languages = Authorization.user?.userLanguages;
  List<String> languageCodes = [];

  TextToSpeechHelper() {
    _initializeTTS();
    languageCodes = languages!
        .where((userLanguage) => userLanguage.language?.code != null)
        .map((userLanguage) => userLanguage.language!.code!)
        .toList();
  }

  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    for (String languageCode in languageCodes) {
      try {
        await _setLanguage(languageCode);
        print("Language set to: $languageCode");
      } catch (e) {
        print("Error setting language: $e");
        continue; // Skip to the next language if there's an error
      }
    }
  }

  Future<void> tellWhatIsInThePicture(String word) async {
    if (word.isNotEmpty) {
      await speak('On this picture, show where the ${word} is.');
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void dispose() {
    _flutterTts.stop();
  }
}

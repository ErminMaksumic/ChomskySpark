import 'package:flutter_tts/flutter_tts.dart';
import 'package:shop/models/user_language.dart';
import 'package:shop/utils/auth_helper.dart';

import '../providers/language_provider.dart';

class TextToSpeechHelper {
  final FlutterTts _flutterTts = FlutterTts();
  List<UserLanguage>? languages = Authorization.user?.userLanguages;
  List<String> languageCodes = [];
  final LanguageProvider _languageProvider = LanguageProvider();
  TextToSpeechHelper() {
    _initializeTTS();
    languageCodes = languages!
        .where((userLanguage) => userLanguage.language?.code != null)
        .map((userLanguage) => userLanguage.language!.code!)
        .toList();
  }

  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.3);
    await _flutterTts
        .setVoice({"name": "en-us-x-sfg#female_1-local", "locale": "en-US"});
  }

  Future<void> _setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
    await _flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> findObject(String word, {String? sentenceTemplate}) async {
    if (word.isEmpty) return;

    for (String languageCode in languageCodes) {
      String? translatedWord =
          await _languageProvider.translateWord(word, languageCode);

      String sentence = sentenceTemplate != null
          ? sentenceTemplate.replaceAll("{word}", translatedWord!)
          : "Find the $translatedWord.";

      await _flutterTts.speak(sentence);
      await _flutterTts.awaitSpeakCompletion(true);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void dispose() {
    _flutterTts.stop();
  }
}

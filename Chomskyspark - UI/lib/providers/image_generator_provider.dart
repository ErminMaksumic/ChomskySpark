import 'package:chomskyspark/providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageGeneratorProvider extends BaseProvider<String> {
  ImageGeneratorProvider() : super("ImageGenerator");
  static const String _cachedImagesKey = 'cached_story_images';
  static const String _lastWordCountKey = 'last_story_word_count';
  static const int _newWordsThreshold = 10;

  List<String>? _cachedImages;
  int? _lastWordCount;

  @override
  String fromJson(data) {
    return data.toString();
  }

  Future<void> _loadCache() async {
    if (_cachedImages != null && _lastWordCount != null) return;

    final prefs = await SharedPreferences.getInstance();
    final cachedImagesJson = prefs.getString(_cachedImagesKey);
    _lastWordCount = prefs.getInt(_lastWordCountKey);

    if (cachedImagesJson != null) {
      _cachedImages = List<String>.from(json.decode(cachedImagesJson));
    }
  }

  Future<void> _saveCache(List<String> images, int wordCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedImagesKey, json.encode(images));
    await prefs.setInt(_lastWordCountKey, wordCount);
    _cachedImages = images;
    _lastWordCount = wordCount;
  }

  Future<int> _getCurrentLearnedWordCount() async {
    try {
      final response = await httpClient!.get(
        Uri.parse("$fullUrl/count"),
        headers: createHeaders(),
      );

      if (isValidResponseCode(response)) {
        return int.parse(response.body);
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<List<String>> generateLearnedWordsImages(int count) async {
    try {
      await _loadCache();
      final currentWordCount = await _getCurrentLearnedWordCount();

      // If we have cached images and not enough new words, return cached images
      if (_cachedImages != null &&
          _lastWordCount != null &&
          currentWordCount - _lastWordCount! < _newWordsThreshold) {
        return _cachedImages!;
      }

      // Generate new images
      final response = await httpClient!.get(
        Uri.parse("$fullUrl/learned-words?count=$count"),
        headers: createHeaders(),
      );

      if (isValidResponseCode(response)) {
        final List<dynamic> jsonList = json.decode(response.body);
        final images = jsonList.map((item) => item.toString()).toList();

        // Save the new images and current word count
        await _saveCache(images, currentWordCount);
        return images;
      } else {
        throw Exception('Failed to generate images: ${response.statusCode}');
      }
    } catch (e) {
      // If we have cached images but failed to generate new ones, return cached
      if (_cachedImages != null) {
        return _cachedImages!;
      }
      throw Exception('Failed to generate images: $e');
    }
  }
}

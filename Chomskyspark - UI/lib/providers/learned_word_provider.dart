import 'dart:convert';

import 'package:chomskyspark/models/learned_word.dart';
import 'package:chomskyspark/providers/base_provider.dart';

class LearnedWordProvider
    extends BaseProvider<LearnedWord> {
  LearnedWordProvider() : super("LearnedWord");

  @override
  LearnedWord fromJson(data) {
    return LearnedWord.fromJson(data);
  }

  Future<int> getLearnedWordsCount(int userId) async {
    try {
      var uri = Uri.parse("$fullUrl/get-learned-words-count-by-user-id/$userId");

      Map<String, String> headers = createHeaders();
      var response = await httpClient!.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load learned words counter');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}

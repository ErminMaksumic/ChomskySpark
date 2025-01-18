import 'dart:convert';

import 'package:chomskyspark/models/language.dart';
import 'package:chomskyspark/models/user.dart';
import 'package:chomskyspark/providers/base_provider.dart';
import 'package:chomskyspark/utils/auth_helper.dart';

class LanguageProvider extends BaseProvider<Language> {
  LanguageProvider() : super("Language");

  @override
  Language fromJson(data) {
    return Language.fromJson(data);
  }

  Future<String?> translateWord(String word, String language) async {
    var url = Uri.parse("$fullUrl");

    Map<String, String> headers = {"Content-Type": "application/json"};
    var jsonRequest = jsonEncode({"word": word, "language": language});
    var response =
        await httpClient!.post(url, headers: headers, body: jsonRequest);

    print(response);
    if (isValidResponseCode(response)) {
      return response.body;
    } else {
      return null;
    }
  }
}

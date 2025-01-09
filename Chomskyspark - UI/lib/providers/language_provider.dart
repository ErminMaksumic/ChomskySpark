import 'dart:convert';

import 'package:shop/models/language.dart';
import 'package:shop/models/user.dart';
import 'package:shop/providers/base_provider.dart';
import 'package:shop/utils/auth_helper.dart';

class LanguageProvider extends BaseProvider<Language> {
  LanguageProvider() : super("Language");

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

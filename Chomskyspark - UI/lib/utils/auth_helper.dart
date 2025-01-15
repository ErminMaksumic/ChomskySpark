import 'package:shop/models/user.dart';

class Authorization {
  static User? user;
  static JWT? jwt;
  static bool useBothLanguages = false;
  static bool childLogged = false;
}

class JWT {
  String? token;
}
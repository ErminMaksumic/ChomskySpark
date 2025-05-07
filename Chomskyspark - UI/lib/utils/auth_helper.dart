import 'package:chomskyspark/models/user.dart';

class Authorization {
  static User? user;
  static JWT? jwt;
  static bool useBothLanguages = false;
  static bool childLogged = false;
  static int? selectedChildId;
}

class JWT {
  String? token;
}
import 'package:shop/models/user.dart';

class Authorization {
  static User? user;
  static JWT? jwt;
}

class JWT {
  String? token;
}
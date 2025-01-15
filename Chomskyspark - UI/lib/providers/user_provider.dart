import 'dart:convert';

import 'package:shop/models/user.dart';
import 'package:shop/providers/base_provider.dart';
import 'package:shop/services/notification_service.dart';
import 'package:shop/utils/auth_helper.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  Future<User> login(String username, String password) async {
    var url = "$fullUrl/login";
    String queryString =
        getQueryString({'username': username, 'password': password});
    url = "$url?$queryString";
    var uri = Uri.parse(url);

    var response = await httpClient!.get(uri);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      print(data);
      Authorization.jwt = JWT()..token = data['token'];
      Authorization.user = await User.fromJson(data['user']);
      NotificationService notificationService = NotificationService();
      await notificationService.initialize();
      return User.fromJson(data['user']);
    } else {
      throw Exception("An error occured!");
    }
  }

  Future<User?> register(dynamic request) async {
    var url = Uri.parse("$fullUrl");

    Map<String, String> headers = {"Content-Type": "application/json"};
    var jsonRequest = jsonEncode(request);
    var response =
        await httpClient!.post(url, headers: headers, body: jsonRequest);

    print(response);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      return null;
    }
  }
}

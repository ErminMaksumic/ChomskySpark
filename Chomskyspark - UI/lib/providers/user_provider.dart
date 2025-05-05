import 'dart:convert';

import 'package:chomskyspark/models/user.dart';
import 'package:chomskyspark/providers/base_provider.dart';
import 'package:chomskyspark/services/notification_service.dart';
import 'package:chomskyspark/utils/auth_helper.dart';

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

  Future<User> loginChild(int id) async {
    var url = "$fullUrl/login-child";
    String queryString =
    getQueryString({'id': id});
    url = "$url?$queryString";
    var uri = Uri.parse(url);

    var response = await httpClient!.get(uri);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      print(data);
      Authorization.jwt = JWT()..token = data['token'];
      return User.fromJson(data['user']);
    } else {
      throw Exception("An error occured!");
    }
  }

  Future<List<User>> getChildren(int parentId) async {
    var url = "$fullUrl/get-children/$parentId";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await httpClient!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data.map((x) => fromJson(x)).cast<User>().toList();
    } else {
      throw Exception("An error occurred!");
    }
  }

  Future<List<MapEntry<int, String>>> getDropdownChildren() async {
    var url = "$fullUrl/get-dropdown-children/${Authorization.user!.id}";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await httpClient!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      final List<dynamic> data = jsonDecode(response.body);
       return data
            .map((e) => MapEntry<int, String>(e['key'], e['value']))
            .toList();
    } else {
      throw Exception("An error occurred!");
    }
  }

}

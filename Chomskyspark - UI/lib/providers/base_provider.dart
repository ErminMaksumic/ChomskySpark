import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:chomskyspark/utils/auth_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  String? _baseUrl;
  String? _endPoint;

  String? fullUrl;

  HttpClient client = HttpClient();
  IOClient? httpClient;

  BaseProvider(String endPoint) {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://10.0.2.2:7164/api");

    if (_baseUrl!.endsWith("/") == false) {
      _baseUrl = "${_baseUrl!}/";
    }

    _endPoint = endPoint;
    client.badCertificateCallback = ((cert, host, port) => true);
    httpClient = IOClient(client);

    fullUrl = "$_baseUrl$_endPoint";
    developer.log('fullUrl', name: fullUrl!);
  }

  Future<T> getById(int id, [dynamic additionalData]) async {
    var url = Uri.parse("$_baseUrl$_endPoint/$id");

    Map<String, String> headers = createHeaders();

    var response = await httpClient!.get(url, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("An error occured!");
    }
  }

  Future<List<T>> get([dynamic search]) async {
    var url = "$_baseUrl$_endPoint";

    if (search != null) {
      String queryString = getQueryString(search);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await httpClient!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data.map((x) => fromJson(x)).cast<T>().toList();
    } else {
      throw Exception("An error occurred!");
    }
  }

  Future<T?> insert(dynamic request) async {
    var url = "$_baseUrl$_endPoint";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var jsonRequest = jsonEncode(request);
    var response =
        await httpClient!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      return null;
    }
  }

  Future<T?> update(int id, [dynamic request]) async {
    var url = "$_baseUrl$_endPoint/$id";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await httpClient!
        .put(uri, headers: headers, body: jsonEncode(request));

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      return null;
    }
  }

  Future<T?> delete(int id) async {
    var url = "$_baseUrl$_endPoint/$id";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await httpClient!.delete(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      return null;
    }
  }

  Map<String, String> createHeaders() {
    String jwtToken = Authorization?.jwt?.token ?? '';
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $jwtToken"
    };
  }

  T fromJson(data) {
    throw Exception("Override method");
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }

  bool isValidResponseCode(Response response) {
    if (response.statusCode == 200) {
      if (response.body != "") {
        return true;
      } else {
        return false;
      }
    } else if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception("Bad request");
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else if (response.statusCode == 403) {
      throw Exception("Forbidden");
    } else if (response.statusCode == 404) {
      throw Exception("Not found");
    } else if (response.statusCode == 500) {
      throw Exception("Internal server error");
    } else {
      throw Exception("An error occurred!");
    }
  }
}

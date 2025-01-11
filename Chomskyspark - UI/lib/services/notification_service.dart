import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shop/utils/auth_helper.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  var _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://10.0.2.2:7164/api");

  Future<void> initialize() async {
    await Firebase.initializeApp();

    await _messaging.requestPermission();

    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    if (token != null) {
      await sendTokenToServer(token);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.body}");
    });
  }

  Future<void> sendTokenToServer(String token) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    var url = "$_baseUrl/Notification/register-token";
    client.badCertificateCallback = ((cert, host, port) => true);
    var httpClient = IOClient(client);

    await httpClient
        .post(Uri.parse(url), body: {'token': token, 'tag': Authorization.user!.id});
  }
}

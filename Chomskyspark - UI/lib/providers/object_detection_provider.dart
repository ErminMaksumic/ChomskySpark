import 'dart:convert';
import 'package:chomskyspark/models/recognized_object.dart';
import 'package:chomskyspark/providers/base_provider.dart';
import 'dart:io';

import 'package:chomskyspark/utils/auth_helper.dart';

class ObjectDetectionProvider extends BaseProvider<File> {
  ObjectDetectionProvider() : super("ObjectDetection");

  Future<List<RecognizedObject>> detectImage(String imageUrl, int childId) async {
    try {
      final String body = jsonEncode({
        'imageUrl': imageUrl,
        'childId': childId,
      });

      var uri = Uri.parse("$fullUrl");
      final response = await httpClient!.post(
        uri,
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Authorization.jwt!.token}'
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((json) => RecognizedObject.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('An error occurred: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getRandomRecognizedObject(int childId) async {
    try {
      var uri = Uri.parse("$fullUrl/$childId");

      Map<String, String> headers = createHeaders();
      var response = await httpClient!.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print(jsonResponse);

        final List<RecognizedObject> recognizedObjects = (jsonResponse['recognizedObjects'] as List)
            .map((json) => RecognizedObject.fromJson(json))
            .toList();

        return {
          'imageUrl': jsonResponse['imageUrl'],
          'recognizedObjects': recognizedObjects,
        };
      } else {
        print('Failed to load recognized objects: ${response.statusCode}');
        throw Exception('Failed to load recognized objects');
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }
}

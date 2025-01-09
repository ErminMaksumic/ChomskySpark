import 'dart:convert';
import 'package:shop/models/recognized_object.dart';
import 'package:shop/providers/base_provider.dart';
import 'dart:io';

class ObjectDetectionProvider extends BaseProvider<File> {
  ObjectDetectionProvider() : super("ObjectDetection");

  Future<List<RecognizedObject>> detectImage(String imageUrl) async {
    try {
      final String body = jsonEncode(imageUrl);
      var uri = Uri.parse("$fullUrl");

      final response = await httpClient!.post(
        uri,
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        return jsonResponse.map((json) => RecognizedObject.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('An error occurred: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getRandomRecognizedObject() async {
    try {
      var uri = Uri.parse("$fullUrl");

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

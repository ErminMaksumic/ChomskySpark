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
}

import 'package:shop/providers/base_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FileProvider extends BaseProvider<File> {
  FileProvider() : super("File");

  Future<void> sendFile(File file) async {
    var url = Uri.parse(fullUrl!);

    var request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath(
      'formFile',
      file.path,
      contentType: MediaType('image', 'png'),
    ));

    var streamedResponse = await httpClient!.send(request);

    if (streamedResponse.statusCode == 200 ||
        streamedResponse.statusCode == 204) {
      print('File uploaded successfully');
      var responseBody = await streamedResponse.stream.bytesToString();
      print('Server response: $responseBody');
    } else {
      print(
          'Failed to upload file. Status Code: ${streamedResponse.statusCode}');
      var responseBody = await streamedResponse.stream.bytesToString();
      print('Error response: $responseBody');
    }
  }
}

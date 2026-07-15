import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:silesra/core/config/settings.dart';

class ImageUploadService {
  static Future<String> uploadImage(File imageFile, String folder) async {
    String url = '$baseUrl/uploadfile/$folder/';
  
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    request.files.add(await http.MultipartFile.fromPath(
      'receiptImage',
      imageFile.path,
      filename: basename(imageFile.path),
    ));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        return jsonResponse[
            'file_url']; // Extract the filename from the response
      } else {
        return "error";
      }
    } catch (e) {
      print('Upload Error: $e');
      return "error";
    }
  }
}

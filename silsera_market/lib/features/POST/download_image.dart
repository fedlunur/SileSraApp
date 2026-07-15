import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silesra/core/config/settings.dart';

/// Abstract class to be implemented by all models that contain images
abstract class DownImageModel {
  List<dynamic>? images; // List of image paths or objects
}

/// Function to download an image and store it in a model-specific folder
Future<String> _downloadImage(String modelName, String url) async {
  final dio = Dio();

  try {
    final tempDir = await getApplicationDocumentsDirectory();
    final modelDir = Directory('${tempDir.path}/$modelName');

    // Create directory if it doesn't exist
    if (!(await modelDir.exists())) {
      await modelDir.create(recursive: true);
    }

    final fileName = url.split('/').last;
    final filePath = '${modelDir.path}/$fileName';
    final file = File(filePath);

    // If file exists, return the path to prevent re-downloading
    if (await file.exists()) {
      return file.path;
    }

    // Download image
    final response =
        await dio.get(url, options: Options(responseType: ResponseType.bytes));
    await file.writeAsBytes(response.data);

    return file.path;
  } catch (e) {
    return 'assets/placeholder.png'; // Default fallback image
  }
}

Future<void> updateImages(String folderName, List<dynamic> items) async {
  print("The images will be downloaded here ");
  for (var item in items) {
    if (item.images != null && item.images!.isNotEmpty) {
      List<String> newImagePaths = [];

      for (var img in item.images!) {
        if (img is Map<String, dynamic> && img.containsKey('imagepath')) {
          final imagePath = img['imagepath'];
          final newPath = await _downloadImage(
              folderName, '$baseUrl/download/listing_images/$imagePath');
          newImagePaths.add(newPath);
        }
      }

      // Replace images with locally stored paths
      item.images!.clear();
      item.images!.addAll(newImagePaths);
    } else {
      // Ensure images are set to default if no valid images exist
      item.images = ['assets/placeholder.png'];
    }

    print('$folderName Image Updated: ${item.images?.last}');
  }
}

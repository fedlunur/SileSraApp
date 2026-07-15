import 'dart:io';
import 'package:flutter/material.dart';
import 'package:silesra/core/config/ImageUploadService.dart';
import 'package:silesra/features/POST/BaseService.dart';

class PostService {
  final List<File> pickedImages;
  final List<File> pickedReciptImages;
  final Map<String, dynamic> formData;
  final BaseService service; // Generic service
  final Function(Map<String, dynamic>)
      fromDict; // Pass the model's from_dict method
  final String api;

  List<String> uploadedImageUrls = [];
  List<String> uploadedReciptImageUrls = [];

  PostService({
    required this.pickedImages,
    required this.pickedReciptImages,
    required this.formData,
    required this.service,
    required this.api,
    required this.fromDict, // Pass the from_dict method
  });

  /// Upload images and return URLs
  Future<void> uploadFiles() async {
    uploadedImageUrls.clear();
    uploadedReciptImageUrls.clear();

    for (var file in pickedImages) {
      String url = await ImageUploadService.uploadImage(file, 'listing_images');
      if (url != "error") uploadedImageUrls.add(url);
    }

    for (var file in pickedReciptImages) {
      String url =
          await ImageUploadService.uploadImage(file, 'Servicefee_images');
      if (url != "error") uploadedReciptImageUrls.add(url);
    }
  }

  /// Convert image URLs to JSON format
  List<Map<String, dynamic>> formatImages(List<String> urls,
      {bool isRecipt = false}) {
    return urls.map((url) {
      return isRecipt
          ? {
              "imagepath": url.split('/').last,
              "feeReciptRefnumber": "12121212",
              "servicefeeBank": 1
            }
          : {
              "imagepath": url.split('/').last,
            };
    }).toList();
  }

  /// Create the final form data and send request
  Future<bool> submitPost(BuildContext context) async {
    await uploadFiles();

    final completeFormData = {
      ...formData,
      "images": formatImages(uploadedImageUrls),
      "reciptimages": formatImages(uploadedReciptImageUrls, isRecipt: true),
    };

    try {
      print("object $completeFormData");
      final response = await service.create(completeFormData, fromDict, api);
      // print(response["data"]);

      if (response["success"] == true && response["data"]["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response["data"]["message"] ??
                  "Record created successfully.")),
        );
        return true; // Successfully created
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response["data"]["message"] ?? "Failed to create.")),
        );
        return false;
      }
    } catch (e) {
      print("submitPost Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
      return false;
    }
  }
}

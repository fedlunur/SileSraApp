// ignore: file_names
import 'dart:io';

class ImageUpmodel {
  final String objectId;
  final String contentTypeId;
  final List<File> listImage;
  final String imagePath;

  ImageUpmodel({
    required this.objectId,
    required this.contentTypeId,
    required this.listImage,
    required this.imagePath,
  });

  // Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'object_id': objectId,
      'content_type_id': contentTypeId,
      'listImage': listImage.map((file) => file.path).toList(),
    };
  }

  // Create an object from a map
  factory ImageUpmodel.fromMap(Map<String, dynamic> map) {
    return ImageUpmodel(
      objectId: map['object_id'] as String,
      contentTypeId: map['content_type_id'] as String,
      listImage: (map['listImage'] as List<dynamic>)
          .map((path) => File(path as String))
          .toList(),
      imagePath: map['imagePath'] as String,
    );
  }

  @override
  String toString() {
    return 'ImageUpmodel(objectId: $objectId, contentTypeId: $contentTypeId, listImage: ${listImage.map((file) => file.path).toList()})';
  }
}

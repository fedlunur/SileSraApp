import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageUploadWidget extends StatefulWidget {
  final Function(List<File>) onFilesPicked; // Callback to pass selected files

  const ImageUploadWidget({super.key, required this.onFilesPicked});

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _imageFiles = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildImageUpload(),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final List<XFile> images;
    if (source == ImageSource.gallery) {
      images = (await _picker.pickMultiImage(imageQuality: 80)) ?? [];
    } else {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      images = image != null ? [image] : [];
    }
    if (images.isNotEmpty) {
      List<File> selectedFiles = images.map((file) => File(file.path)).toList();

      // Limit to 5 images if needed
      if (selectedFiles.length > 5) {
        selectedFiles = selectedFiles.take(5).toList();
      }

      setState(() {
        _imageFiles = selectedFiles;
      });

      // Send the list of File objects to the parent
      widget.onFilesPicked(_imageFiles);
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
      widget.onFilesPicked(_imageFiles); // Update parent with new list
    });
    // Ensure the UI rebuilds to reflect the change
    setState(() {});
  }

  Widget _buildImageUpload() {
    return GestureDetector(
      onTap: _showImageSourceOptions, // Trigger the options dialog
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: _imageFiles.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 50, color: Colors.grey),
                  Text("Upload Images", style: TextStyle(color: Colors.grey)),
                ],
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: _imageFiles.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Image.file(
                        _imageFiles[index],
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 2, // Reduced from 4 to 2 for tighter positioning
                        right: 2, // Reduced from 4 to 2 for tighter positioning
                        child: GestureDetector(
                          onTap: () => _removeImage(
                              index), // Ensure this triggers removal
                          child: Container(
                            decoration: const BoxDecoration(
                              color:
                                  Colors.red, // Fully opaque red (100% opacity)
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

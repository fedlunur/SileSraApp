import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';



class PaymentWidget extends StatefulWidget {
  final Function(List<File>)
      onFilesPicked; // Callback to pass multiple file paths

  const PaymentWidget({super.key, required this.onFilesPicked});

  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _imageFiles = [];
  String pickedbank = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _payment(),
        const SizedBox(height: 20),
        // ElevatedButton(
        //  // onPressed: () => showPaymentOptions(context),
        //   child: Text("How to Pay?"),
        // ),
      ],
    );
  }

  Widget _payment() {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Additional Ad Price",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF168AE3)),
            ),
            const SizedBox(height: 10),
            _buildAdPriceItem("Houses", "15 Br / ad"),
            _buildAdPriceItem("Cars", "14 Br / ad"),
            _buildAdPriceItem("Other items", "5 Br / ad"),
            _buildAdPriceItem("Service ads", "4 Br / ad"),
            _buildAdPriceItem("Wanted ads", "4 Br / ad"),
            _buildAdPriceItem("Job ads", "150 Br / ad"),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => showPaymentOptions(context),
                  child: const Text("How to Pay ?"),
                ),
              ],
            ),
            _buildImageUpload(),

          ],
        ),
      ),
    );
  }

  Widget _buildAdPriceItem(String title, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          Text(price,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
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
                        top: 2, // Position at the top
                        right: 2, // Position at the right
                        child: GestureDetector(
                          onTap: () => _removeImage(index), // Ensure this triggers removal
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red, // Fully opaque red (100% opacity)
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

  Widget paymentButton(
      BuildContext context, String text, Color color, String imagePath) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          showPaymentDetails(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 24,
                width: 24,
                child: Image.asset(imagePath, fit: BoxFit.contain)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPaymentOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8FCFF),
          title: const Text("How to Pay", style: TextStyle(color: Color(0xFF168AE3))),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Pay what you feel will need for a month or more"),
                const SizedBox(height: 10),
                paymentButton(
                    context, "Pay with CBE", Colors.orange, "assets/cbe.png"),
                const SizedBox(height: 10),
                paymentButton(context, "Pay with TeleBirr",
                    const Color(0xFF168AE3), "assets/telebirr.png"),
                const SizedBox(height: 10),
                paymentButton(context, "Pay with CbeBirr", Colors.purple,
                    "assets/cbebirr.png"),
                const SizedBox(height: 10),
                const Text(
                  "Note: Payments sent via other methods won't be accepted",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPaymentDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF8FCFF),
              title: const Text("How to Pay",
                  style: TextStyle(color: Color(0xFF168AE3))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Transfer an amount to the account below:"),
                  const SizedBox(height: 10),
                  const SelectableText(
                    "CBE Bank Account\n Silesra \n1000*****4566",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(const Color(0xFF168AE3)),
                    ),
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: "1000*******"));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Account number copied!")),
                      );
                    },
                    child: const Text("Copy Account Number",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  const Text("Then send a screenshot of the verification SMS."),
                  const SizedBox(height: 10),

                  // Image preview logic

                  // Cancel button to close the dialog
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("CANCEL"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
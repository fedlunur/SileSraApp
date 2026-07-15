import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:silesra/core/config/ImageUploadService.dart';
import 'package:silesra/features/News/Block/block.dart';
import 'package:silesra/features/News/Block/event.dart';
import 'package:silesra/features/News/models/models.dart';
import 'package:silesra/features/Product/presentation/screens/profile_page.dart';
import 'package:silesra/features/Product/presentation/widgets/PreimumPaymentWidget.dart';

class PreimumPaymentScreen extends StatefulWidget {
  final int userId;
  final PremiumPlan selectedPlanId;

  const PreimumPaymentScreen({
    Key? key,
    required this.userId,
    required this.selectedPlanId,
  }) : super(key: key);

  @override
  State<PreimumPaymentScreen> createState() => _PreimumPaymentScreenState();
}

class _PreimumPaymentScreenState extends State<PreimumPaymentScreen> {
  List<File> pickedPaymentFiles = [];
  List<String> uploadedReciptImageUrls = [];
  List<Map<String, dynamic>> formatImages(List<String> urls,
      {bool isRecipt = true}) {
    return urls.map((url) {
      return isRecipt
          ? {
              "imagepath": url.split('/').last,
              "feeReciptRefnumber": "12121212",
            }
          : {
              "imagepath": url.split('/').last,
            };
    }).toList();
  }

  Future<void> uploadFiles() async {
    uploadedReciptImageUrls.clear();
    for (var file in pickedPaymentFiles) {
      String url =
          await ImageUploadService.uploadImage(file, 'premium_service_fees');
      if (url != "error") uploadedReciptImageUrls.add(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Complete Payment",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            // color: Colors.white,
          ),
        ),
        // backgroundColor: const Color.fromARGB(255, 166, 210, 243),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PreimumPaymentWidget(
              onFilesPicked: (files) {
                setState(() {
                  pickedPaymentFiles = files;
                });
              },
              Selectedplan: widget.selectedPlanId,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (pickedPaymentFiles == null ||
                      pickedPaymentFiles.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please upload the screenshot!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return; // prevent showing the dialog
                  } else {
                    _showConfirmationDialog(
                      context,
                      widget.userId,
                      widget.selectedPlanId.id,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 161, 214, 255),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Submit Your Premium Request",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext parentContext, int userId, int selectedPlanId) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Are you sure you want to submit plan request?"),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          try {
                            setState(() => isLoading = true);

                            // 1. Upload receipt files
                            await uploadFiles();

                            // 2. Format the uploaded receipt data
                            List<Map<String, dynamic>> reciptImagesData =
                                formatImages(uploadedReciptImageUrls,
                                    isRecipt: true);

                            // 3. Dispatch event with full payload
                            parentContext
                                .read<PromotionsPlansNewsBloc>()
                                .add(CreatePremiumRequestEvent(
                                  userId: userId,
                                  selectedPlanId: selectedPlanId,
                                  receiptImages: reciptImagesData,
                                ));

                            // 4. Optional delay for UX smoothness
                            await Future.delayed(const Duration(seconds: 1));

                            setState(() => isLoading = false);
                            Navigator.of(dialogContext).pop();

                            // 5. Refresh data
                            parentContext.read<PromotionsPlansNewsBloc>().add(
                                FetchPromotionsPlansAndNews(userId: userId));

                            // 6. Show success message
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Request submitted successfully."),
                                backgroundColor: Colors.green,
                              ),
                            );
                            GoRouter.of(parentContext).go('/profile');
                          } catch (e) {
                            setState(() => isLoading = false);
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Text("Error submitting request: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text("No"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

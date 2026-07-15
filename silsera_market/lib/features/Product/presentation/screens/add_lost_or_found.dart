// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:silesra/core/config/settings.dart';
import 'package:silesra/core/config/shareddata.dart';
import 'package:silesra/features/LOF/data/model/lof_model.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/POST/PostService.dart';
import 'package:silesra/features/Product/presentation/widgets/ImageUploadWidget.dart';
import 'package:silesra/features/Product/presentation/widgets/paymentwidgets.dart';

class AddLostOrFound extends StatefulWidget {
  final String city;
  final int catagory;

  const AddLostOrFound({super.key, required this.city, required this.catagory});

  @override
  _PropertyStepperState createState() => _PropertyStepperState();
}

class _PropertyStepperState extends State<AddLostOrFound> {
  final lofService = ListingProvider().lofService;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  // Form Inputs
  String name = ''; // New field for the name
  String title = '';
  String description = '';
  String? selectedLostOrFoundType;
  List<File> pickedImageFiles = [];
  List<File> pickedPaymentFiles = [];

  Future productCreate(BuildContext context) async {
    bool isSuccess = await PostService(
      pickedImages: pickedImageFiles,
      pickedReciptImages: pickedPaymentFiles,
      api: 'lostorfoud',
      service: lofService,
      fromDict: LostOrFound.from_dict,
      formData: {
        //'name': name, // Include the name field in the formData
        'title': title,
        'description': description,
        'typeofadd': 'I need help looking for something I lost',
        'city': widget.city,
        ...SharedData().getCommonData(),
      },
    ).submitPost(context);
    return isSuccess;
  }

  void _showConfirmationDialog(BuildContext parentContext) {
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
                  const Text("Are you sure you want to submit?"),
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
                            if (!await _validateCurrentStepForPayment()) {
                              return;
                            }
                            setState(() => isLoading = true);
                            bool isSuccess = await productCreate(dialogContext);
                            setState(() => isLoading = false);

                            if (isSuccess) {
                              Navigator.of(dialogContext).pop();
                              GoRouter.of(context)
                                  .go('/successpage?catagoryname=$title');
                            } else {
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      "Submission failed. Please try again."),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() => isLoading = false);
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Error: Invalid input. Please check your data. $e"),
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

  Future<bool> _validateCurrentStepForPayment() async {
    int tempStep = _currentStep;
    _currentStep = 2;
    bool isValid = await _validateCurrentStep();
    _currentStep = tempStep;
    return isValid;
  }

  Future<bool> _validateCurrentStep() async {
    switch (_currentStep) {
      case 0:
        if (_formKey.currentState?.validate() ?? false) {
          // if (name.isEmpty || title.isEmpty || description.isEmpty || selectedLostOrFoundType == null) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text("Please fill all required fields.")),
          //   );
          //   return false;
          // }
          return true;
        }
        return false;

      case 1:
        if (pickedImageFiles.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please upload at least one image.")),
          );
          return false;
        }
        return true;

      case 2:
        if (pickedPaymentFiles.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please upload payment receipt.")),
          );
          return false;
        }
        return true;

      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      appBar: AppBar(
        title: Text('Post Lost or Found - ${widget.city}'),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/add?city=${widget.city}'),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF8FCFF),
        child: Theme(
          data: ThemeData(
              colorScheme: const ColorScheme.light(primary: Color(0xFF168AE3))),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () async {
              if (_currentStep < 2) {
                if (await _validateCurrentStep()) {
                  setState(() => _currentStep++);
                }
              } else {
                _showConfirmationDialog(context);
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            onPressed: details.onStepCancel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Color(0xFF168AE3)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            child: const Text("Back"),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF168AE3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: Text(_currentStep == 2 ? "Submit" : "Next"),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text("Details"),
                content: _buildDetailsForm(),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 0 ? StepState.editing : StepState.complete,
              ),
              Step(
                title: const Text("Images"),
                content: ImageUploadWidget(
                    onFilesPicked: (files) =>
                        setState(() => pickedImageFiles = files)),
                isActive: _currentStep >= 1,
                state:
                    _currentStep > 1 ? StepState.editing : StepState.complete,
              ),
              Step(
                title: const Text("Payment"),
                content: PaymentWidget(
                    onFilesPicked: (files) =>
                        setState(() => pickedPaymentFiles = files)),
                isActive: _currentStep >= 2,
                state:
                    _currentStep > 2 ? StepState.editing : StepState.complete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildTextField("Name"), // Added Name Field
          const SizedBox(height: 10),
          _buildTextField("Title"),
          const SizedBox(height: 10),
          _buildLostOrFoundTypeSelection(),
          const SizedBox(height: 10),
          _buildTextField("Description", maxLines: 5),
        ],
      ),
    );
  }

  Widget _buildLostOrFoundTypeSelection() {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select Type (Lost or Found)"),
      items: lostOrFoundTypes.map((String type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) => setState(() => selectedLostOrFoundType = value),
      validator: (value) =>
          value == null ? 'Please select Lost or Found' : null,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildTextField(String label,
      {int maxLines = 1, bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: _inputDecoration(label),
        maxLines: maxLines,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
        onChanged: (value) {
          if (label == "Name") {
            name = value; // Update the name field
          } else if (label == "Title") {
            title = value;
          } else if (label == "Description") {
            description = value;
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          if (isNumeric && double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.grey[850], fontSize: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF168AE3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF168AE3)),
      ),
    );
  }
}

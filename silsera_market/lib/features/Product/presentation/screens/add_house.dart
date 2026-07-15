// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:flutter/services.dart';

import 'package:silesra/core/config/settings.dart';
import 'package:silesra/core/config/shareddata.dart';

import 'package:silesra/features/House/data/model/house_model.dart';

import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/POST/PostService.dart';

import 'package:silesra/features/Product/presentation/widgets/ImageUploadWidget.dart';
import 'package:silesra/features/Product/presentation/widgets/paymentwidgets.dart';
// Ensure this imports ListingProvider

class AddHouseProperty extends StatefulWidget {
  final String city;
  final int catagory;

  const AddHouseProperty({super.key, required this.city, required this.catagory});

  @override
  _PropertyStepperState createState() => _PropertyStepperState();
}

class _PropertyStepperState extends State<AddHouseProperty> {
  bool isUploading = false;
  String? feeReciptRefnumber;
  String? feeReciptImagePath;
  String? servicefeeBank;
  final houseService = ListingProvider().houseService;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form Inputs
  String? saleOrRent;
  String propertyType = '';
  String bedrooms = '';
  String bathrooms = '';
  String price = '';
  String squareMeters = '';
  String description = '';
  String name = '';

  String selectedHouseType = '';
  String? selectedBank;
  File? paymentScreenshot;
  String uploadedImagePath = "";
  List<String> uploadedImageList = [];

  late String selectedCity = '';

  List<File> pickedPaymentFiles = [];
  List<File> pickedImageFiles = []; // To store selected images

  Future<bool> productCreate(BuildContext context) async {
    print(" %%%%%%  Shared Data is now called  !!!!!!!");
    print(SharedData().getCommonData());
    bool isSuccess = await PostService(
      pickedImages: pickedImageFiles,
      pickedReciptImages: pickedPaymentFiles,
      api: 'house',
      service: houseService,
      fromDict: HouseModel.fromJson,
      formData: {
        'area': squareMeters,
        'name': name,
        "sell_or_rent": propertyType,
        "houseType": selectedHouseType,
        "numberofBedrooms": bedrooms,
        "numberofBathrooms": bathrooms,
        "price": price,
        "description": description,
        ...SharedData().getCommonData(),
      },
    ).submitPost(context);

    return isSuccess;
  }

  String getPriceLabel() {
    return propertyType == "Sale" ? "Selling Price" : "Rent Price (per month)";
  }

  void _showConfirmationDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierDismissible: false, // Prevent dismissing while submitting
      builder: (BuildContext dialogContext) {
        bool isLoading = false; // Track loading state

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
                      child:
                          CircularProgressIndicator(), // Show loading indicator
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null // Disable button when loading
                      : () async {
                          try {
                            // Validate input fields before proceeding
                            if (bedrooms == "" || bathrooms == "") {
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please fill all required fields with valid values."),
                                ),
                              );
                              return;
                            }

                            setState(() => isLoading = true); // Start loading

                            bool isSuccess = await productCreate(dialogContext);

                            setState(() => isLoading = false); // Stop loading
                            if (isSuccess) {
                              Navigator.of(dialogContext)
                                  .pop(); // Close dialog first
                              // Ensure navigation happens after dialog is completely closed

                              GoRouter.of(context)
                                  .go('/successpage?catagoryname=$name');
                            }
                          } catch (e) {
                            setState(() => isLoading = false); // Stop loading
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
                      : () {
                          Navigator.of(dialogContext).pop();
                        },
                  child: const Text("No"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      appBar: AppBar(
        title: const Text('Add House'),
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
          onPressed: () {
            context.go('/add?city=${widget.city}');
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF8FCFF),
        child: Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF168AE3),
            ),
          ),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () {
              // Ensure the form is validated before proceeding
              if (_currentStep == 0 && !_formKey.currentState!.validate()) {
                return; // Do not proceed if form is invalid
              }

              if (_currentStep < 2) {
                setState(() => _currentStep++);
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
                                borderRadius: BorderRadius.circular(8.0),
                              ),
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
                              borderRadius: BorderRadius.circular(8.0),
                            ),
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
                  onFilesPicked: (files) {
                    setState(() {
                      pickedImageFiles = files;
                    });
                  },
                ),
                isActive: _currentStep >= 1,
                state:
                    _currentStep > 1 ? StepState.editing : StepState.complete,
              ),
              Step(
                title: const Text("Payment"),
                content: PaymentWidget(
                  onFilesPicked: (files) {
                    setState(() {
                      pickedPaymentFiles = files;
                    });
                  },
                ),
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
          Row(
            children: [
              Expanded(child: _buildTextField("Name")),
            ],
          ),
          // Property Type Selection
          const Text("Is the property for Sale or Rent?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 92, 88, 88),
              )),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  activeColor: const Color(0xFF168AE3),
                  title: Text("Sale",
                      style: TextStyle(color: Colors.grey[850], fontSize: 16)),
                  value: "Sale",
                  groupValue: propertyType,
                  onChanged: (value) {
                    setState(() => propertyType = value.toString());
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  activeColor: const Color(0xFF168AE3),
                  title: Text("Rent",
                      style: TextStyle(color: Colors.grey[850], fontSize: 16)),
                  value: "Rent",
                  groupValue: propertyType,
                  onChanged: (value) {
                    setState(() => propertyType = value.toString());
                  },
                ),
              ),
            ],
          ),
          if (propertyType.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Text(
                'Please select either Sale or Rent',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          _buildHouseTypeSelection(),
          // Show Bedrooms & Bathrooms only for specific house types
          if (selectedHouseType == "Apartment" ||
              selectedHouseType == "Condominium" ||
              selectedHouseType == "House G+") ...[
            Row(
              children: [
                Expanded(child: _buildTextField("Bedrooms", isNumeric: true)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField("Bathrooms", isNumeric: true)),
              ],
            ),
          ],

          Row(
            children: [
              Expanded(
                child: _buildTextField(getPriceLabel(), isNumeric: true),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildTextField("Square Meters", isNumeric: true)),
            ],
          ),

          _buildTextField("Description", maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildHouseTypeSelection() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select House Type"),
      items: houseTypes.map((String type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) => setState(() => selectedHouseType = value!),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null) {
          return 'Please select a house type';
        }
        return null;
      },
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
          if (label == "Bedrooms") {
            bedrooms = value;
          } else if (label == "Bathrooms") {
            bathrooms = value;
          } else if (label == getPriceLabel()) {
            price = value;
          } else if (label == "Square Meters") {
            squareMeters = value;
          } else if (label == "Name") {
            name = value;
          } else if (label == "Description") {
            description = value;
          }
        },
        validator: (value) {
          print(" %%%%%%%  Validation is called ====>  $value");
          if (isNumeric && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          if (isNumeric && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          if (!isNumeric && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          if (isNumeric && int.tryParse(value!) == null) {
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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

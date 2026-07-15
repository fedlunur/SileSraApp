import 'dart:io';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:silesra/core/config/settings.dart';
import 'package:silesra/core/config/shareddata.dart';
import 'package:silesra/features/Fashion/data/model/fashion_model.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/POST/PostService.dart';
import 'package:silesra/features/Product/presentation/widgets/ImageUploadWidget.dart';
import 'package:silesra/features/Product/presentation/widgets/paymentwidgets.dart';

class AddFashion extends StatefulWidget {
  final String city;
  final int category;

  const AddFashion({super.key, required this.city, required this.category});

  @override
  _PropertyStepperState createState() => _PropertyStepperState();
}

class _PropertyStepperState extends State<AddFashion> {
  final fashionService = ListingProvider().fashionService;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  // Form Inputs
  String name = '';
  String price = '';
  String description = '';
  String propertyType = '';
  String? selectedFashionType;
  String? selectedGender;
  String? selectedSize;
  String? selectedMaterial;
  String? selectedCondition;
  String? brand;
  List<File> pickedImageFiles = [];
  List<File> pickedPaymentFiles = [];

  Future productCreate(BuildContext context) async {
    bool isSuccess = await PostService(
      pickedImages: pickedImageFiles,
      pickedReciptImages: pickedPaymentFiles,
      api: 'fashion',
      service: fashionService,
      fromDict: FashionModel.from_dict,
      formData: {
        'name': name,
        "sell_or_rent": propertyType,
        'type': selectedFashionType,
        'gender': selectedGender,
        'size': selectedSize,
        'material': selectedMaterial,
        'condition': 'new',
        'price': price,
        'description': description,
        'brand': brand,
        'city': widget.city,
        ...SharedData().getCommonData(),
      },
    ).submitPost(context);
    return isSuccess;
  }

  String getPriceLabel() {
    return propertyType == "Sale" ? "Selling Price" : "Rent Price (per month)";
  }

  void showConfirmationDialog(BuildContext parentContext) {
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
                                  .go('/successpage?catagoryname=$name');
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
          if (name.isEmpty ||
              price.isEmpty ||
              description.isEmpty ||
              selectedFashionType == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please fill all required fields.")),
            );
            return true;
          }

          // Conditional validations based on fashion type
          if (selectedFashionType == "Clothing" ||
              selectedFashionType == "Footwear" ||
              selectedFashionType == "Hats & Caps") {
            if (selectedGender == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Gender is required for this fashion type.")),
              );
              return false;
            }
          }

          if (selectedFashionType == "Clothing" ||
              selectedFashionType == "Footwear" ||
              selectedFashionType == "Bags") {
            if (selectedSize == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Size is required for this fashion type.")),
              );
              return false;
            }
          }

          if (selectedFashionType == "Footwear" ||
              selectedFashionType == "Bags" ||
              selectedFashionType == "Jewelry") {
            if (selectedMaterial == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text("Material is required for this fashion type.")),
              );
              return false;
            }
          }

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
            const SnackBar(
                content: Text("Please upload payment receipt.")),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FCFF),
        appBar: AppBar(
          title: const Text('Add Fashion'),
          backgroundColor: Colors.white,
          elevation: 1,
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
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
              colorScheme:
                  const ColorScheme.light(primary: Color(0xFF168AE3)),
            ),
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () async {
                if (_currentStep < 2) {
                  if (await _validateCurrentStep()) {
                    setState(() => _currentStep++);
                  }
                } else {
                  showConfirmationDialog(context);
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
                                side:
                                    const BorderSide(color: Color(0xFF168AE3)),
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
                        setState(() => pickedImageFiles = files),
                  ),
                  isActive: _currentStep >= 1,
                  state:
                      _currentStep > 1 ? StepState.editing : StepState.complete,
                ),
                Step(
                  title: const Text("Payment"),
                  content: PaymentWidget(
                    onFilesPicked: (files) =>
                        setState(() => pickedPaymentFiles = files),
                  ),
                  isActive: _currentStep >= 2,
                  state:
                      _currentStep > 2 ? StepState.editing : StepState.complete,
                ),
              ],
            ),
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
          Text("Is the property for Sale or Rent?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              )),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  activeColor: propertyType.isEmpty
                      ? Colors.red
                      : const Color(0xFF168AE3),
                  title: Text(
                    "Sale",
                    style: TextStyle(color: Colors.grey[850], fontSize: 16),
                  ),
                  value: "Sale",
                  groupValue: propertyType,
                  onChanged: (value) =>
                      setState(() => propertyType = value.toString()),
                ),
              ),
              Expanded(
                child: RadioListTile(
                  activeColor: propertyType.isEmpty
                      ? Colors.red
                      : const Color(0xFF168AE3),
                  title: Text(
                    "Rent",
                    style: TextStyle(color: Colors.grey[850], fontSize: 16),
                  ),
                  value: "Rent",
                  groupValue: propertyType,
                  onChanged: (value) =>
                      setState(() => propertyType = value.toString()),
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
          _buildTextField("Name"),
          const SizedBox(height: 10),
          _buildFashionTypeSelection(),
          const SizedBox(height: 10),
          _buildGenderSelection(),
          const SizedBox(height: 10),
          _buildSizeSelection(),
          const SizedBox(height: 10),
          _buildMaterialSelection(),
          const SizedBox(height: 10),
          _buildTextField("Brand", isOptional: true),
          const SizedBox(height: 10),
          _buildConditionSelection(),
          const SizedBox(height: 10),
          _buildTextField(getPriceLabel(), isNumeric: true),
          _buildTextField("Description", maxLines: 5),
        ],
      ),
    );
  }

  Widget _buildConditionSelection() {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select Condition"),
      items: conditions.map((String condition) {
        return DropdownMenuItem(value: condition, child: Text(condition));
      }).toList(),
      onChanged: (value) => setState(() => selectedCondition = value),
      validator: (value) => value == null && selectedFashionType != "Other"
          ? 'Please select a condition'
          : null,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildMaterialSelection() {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select Material"),
      items: materials.map((String material) {
        return DropdownMenuItem(value: material, child: Text(material));
      }).toList(),
      onChanged: (value) => setState(() => selectedMaterial = value),
      validator: (value) => value == null &&
              (selectedFashionType == "Footwear" ||
                  selectedFashionType == "Bags" ||
                  selectedFashionType == "Jewelry")
          ? 'Please select a material'
          : null,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildSizeSelection() {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select Size"),
      items: sizes.map((String size) {
        return DropdownMenuItem(value: size, child: Text(size));
      }).toList(),
      onChanged: (value) => setState(() => selectedSize = value),
      validator: (value) => value == null &&
              (selectedFashionType == "Clothing" ||
                  selectedFashionType == "Footwear" ||
                  selectedFashionType == "Bags")
          ? 'Please select a size'
          : null,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildGenderSelection() {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select Gender"),
      items: genderOptions.map((String gender) {
        return DropdownMenuItem(value: gender, child: Text(gender));
      }).toList(),
      onChanged: (value) => setState(() => selectedGender = value),
      validator: (value) => value == null &&
              (selectedFashionType == "Clothing" ||
                  selectedFashionType == "Footwear" ||
                  selectedFashionType == "Hats & Caps")
          ? 'Please select a gender'
          : null,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildFashionTypeSelection() {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select Fashion Type"),
      items: fashionTypes.map((String type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) => setState(() => selectedFashionType = value),
      validator: (value) =>
          value == null ? 'Please select a fashion type' : null,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildTextField(String label,
      {int maxLines = 1, bool isNumeric = false, bool isOptional = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: _inputDecoration(label),
        maxLines: maxLines,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
        onChanged: (value) {
          if (label == getPriceLabel()) {
            price = value;
          } else if (label == "Name") {
            name = value;
          } else if (label == "Description") {
            description = value;
          } else if (label == "Brand") {
            brand = value;
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (!isOptional) {
              return 'This field is required';
            }
          }
          if (isNumeric && double.tryParse(value!) == null) {
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

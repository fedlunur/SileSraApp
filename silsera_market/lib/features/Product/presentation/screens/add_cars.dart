import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:silesra/core/config/settings.dart';
import 'package:silesra/core/config/shareddata.dart';
import 'package:silesra/features/Cars/data/models/car_model.dart';

import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/POST/PostService.dart';
import 'package:silesra/features/Product/presentation/widgets/ImageUploadWidget.dart';
import 'package:silesra/features/Product/presentation/widgets/paymentwidgets.dart';

class AddCarProperty extends StatefulWidget {
  final String city;
  final int catagory;

  const AddCarProperty({super.key, required this.city, required this.catagory});
  @override
  _PropertyStepperState createState() => _PropertyStepperState();
}

class _PropertyStepperState extends State<AddCarProperty> {
  final carService = ListingProvider().carService;

  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();

  // Form Inputs
  String propertyType = '';
  late CarType carType;
  late CarSubType carSubType;
  String name = '';
  String fuelType = 'Benzin'; // Set the default value
  String price = '';
  String yearOfMake = '';
  String model = '';
  String description = '';
  String selectedCity = '';
  String? mileage = '';
  String? selectedBank;
  String? license = '';
  File? paymentScreenshot;
  String? feeReciptRefnumber;
  String uploadedImagePath = "";
  String? transmissionType;
  List<CarType> carTypes = [];
  List<CarSubType> carSubTypes = [];
  List<File> pickedPaymentFiles = [];
  List<File> pickedImageFiles = [];

  Future<bool> productCreate(BuildContext context) async {
    bool isSuccess = await PostService(
      pickedImages: pickedImageFiles,
      pickedReciptImages: pickedPaymentFiles,
      api: 'car',
      service: carService,
      fromDict: CarModel.from_dict,
      formData: {
        'name': name,
        "carType": carType.id,
        "carsubType": carSubType.id,
        "transmission": transmissionType,
        "sell_or_rent": propertyType,
        "yearofMake": yearOfMake,
        "price": price,
        "model": model,
        "fuelType": fuelType,
        "mileage": mileage,
        "license": license,
        "description": description,
        ...SharedData().getCommonData(),
      },
    ).submitPost(context);
    return isSuccess;
  }

  @override
  void initState() {
    super.initState();

    loadCarTypes();
  }

  Future<void> loadCarTypes() async {
    try {
      List<CarType> types = await ApiService.fetchCarTypes();
      List<CarSubType> subtypes = await ApiService.fetchCarSubTypes();
      print("%%% Error loading car types: $types  and sub types $subtypes");
      setState(() {
        carTypes = types;
        carSubTypes = subtypes;
      });
    } catch (e) {
      print("Error loading car types: $e");
    }
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
                            if (carSubType == "") {
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
    int cat = widget.catagory;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      appBar: AppBar(
        title: const Text("Add Car "),
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
          Text("Is the car for Sale or Rent?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              )),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  activeColor: const Color(0xFF168AE3),
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
                  activeColor: const Color(0xFF168AE3),
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
          _buildCarTypeSelection(),
          const SizedBox(height: 10),
          _buildCarSubTypeSelection(),
          const SizedBox(height: 10),
          Text(
            "Choose Transmission",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Row(
          
            children: [
              Expanded(
                child: RadioListTile(
                  activeColor: const Color(0xFF168AE3),
                  title: Text(
                    "Automatic",
                    style: TextStyle(color: Colors.grey[850], fontSize: 12),
                  ),
                  value: "Automatic",
                  groupValue: transmissionType,
                  onChanged: (value) =>
                      setState(() => transmissionType = value.toString()),
                ),
              ),
              Expanded(
                child: RadioListTile(
                  activeColor: const Color(0xFF168AE3),
                  title: Text(
                    "Manual",
                    style: TextStyle(color: Colors.grey[850], fontSize: 12),
                  ),
                  value: "Manual",
                  groupValue: transmissionType,
                  onChanged: (value) =>
                      setState(() => transmissionType = value.toString()),
                ),
              ),
            ],
          ),
          _buildCarFuelTypeSelection(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTextField(getPriceLabel(), isNumeric: true),
              ),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField("Year of Make", isNumeric: true)),
            ],
          ),
          const SizedBox(width: 10),
          _buildTextField("Model"),
          const SizedBox(width: 10),
          Text("Do you have license ?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              )),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  activeColor: const Color(0xFF168AE3),
                  title: Text(
                    "Yes",
                    style: TextStyle(color: Colors.grey[850], fontSize: 16),
                  ),
                  value: "Yes",
                  groupValue: license,
                  onChanged: (value) =>
                      setState(() => license = value.toString()),
                ),
              ),
              Expanded(
                child: RadioListTile(
                  activeColor: const Color(0xFF168AE3),
                  title: Text(
                    "No",
                    style: TextStyle(color: Colors.grey[850], fontSize: 16),
                  ),
                  value: "No",
                  groupValue: license,
                  onChanged: (value) =>
                      setState(() => license = value.toString()),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: _buildTextField("Mileage")),
            ],
          ),
          _buildTextField("Description", maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildCarTypeSelection() {
    return DropdownButtonFormField<CarType>(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select Car Type"),
      items: carTypes.map((CarType type) {
        return DropdownMenuItem<CarType>(
            value: type, // Store the whole object, not just the name
            child: Text(type.name));
      }).toList(),
      onChanged: (CarType? newValue) => setState(() => carType = newValue!),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Color.fromARGB(255, 23, 23, 23)),
    );
  }

  Widget _buildCarSubTypeSelection() {
    return DropdownButtonFormField<CarSubType>(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select Car Sub Type"),
      items: carSubTypes.map((CarSubType type) {
        return DropdownMenuItem<CarSubType>(
            value: type, // Store the whole object, not just the name
            child: Text(type.name));
      }).toList(),
      onChanged: (value) => setState(() => carSubType = value!),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildCarFuelTypeSelection() {
    return DropdownButtonFormField<String>(
      value: fuelType, // Ensure a valid initial value
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Choose Fuel Type"),
      items: carFuelTypes.map((String type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) => setState(() => fuelType = value!),
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
          if (label == getPriceLabel()) {
            price = value;
          } else if (label == "Year of Make") {
            yearOfMake = value;
          } else if (label == "Model") {
            model = value;
          } else if (label == "Mileage") {
            mileage = value;
          } else if (label == "Name") {
            name = value;
          } else if (label == "Description") {
            description = value;
          }
        },
        validator: (value) {
          if (isNumeric && (value == null || value.isEmpty)) {
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

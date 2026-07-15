import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:silesra/core/config/settings.dart';
import 'dart:io';
import 'package:silesra/core/config/shareddata.dart';
import 'package:silesra/features/Job/data/model/job_vacancy.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/POST/PostService.dart';
import 'package:silesra/features/Product/presentation/widgets/ImageUploadWidget.dart';
import 'package:silesra/features/Product/presentation/widgets/paymentwidgets.dart';

class AddJobVacancy extends StatefulWidget {
  final String city;
  final int catagory;

  const AddJobVacancy({super.key, required this.city, required this.catagory});

  @override
  _PropertyStepperState createState() => _PropertyStepperState();
}

class _PropertyStepperState extends State<AddJobVacancy> {
  final jobService = ListingProvider().jobService;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  // Form Inputs
  String name = '';
  String companyName = '';
  String positionTitle = '';
  String workLocation = '';
  String salary = '';
  String applicationDeadline = '';
  String jobDescription = '';
  String jobRequirement = '';
  String? selectedPositionType;
  String? selectedExperienceLevel;
  List<File> pickedImageFiles = [];
  List<File> pickedPaymentFiles = [];

  // Controller for Application Deadline
  final TextEditingController _deadlineController = TextEditingController();

  Future productCreate(BuildContext context) async {
    if (_formKey.currentState != null) {
      _formKey.currentState!.save();
    }

    bool isSuccess = await PostService(
      pickedImages: pickedImageFiles,
      pickedReciptImages: pickedPaymentFiles,
      api: 'jobvacancy',
      service: jobService,
      fromDict: JobVacancyModel.fromJson,
      formData: {
        'companyName': companyName,
        'positionTitle': positionTitle,
        'worklocation': workLocation,
        'positionType': selectedPositionType,
        'experianceLevel': selectedExperienceLevel,
        'salary': salary,
        'applicationDeadline': applicationDeadline,
        'JobDescription': jobDescription,
        'JobRequirment': jobRequirement,
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
                              GoRouter.of(context).go(
                                  '/successpage?catagoryname=$positionTitle');
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
          _formKey.currentState!.save();
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
        title: Text('Post Job Vacancy - ${widget.city}'),
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
          _buildTextField("Position Title"),
          const SizedBox(height: 10),
          _buildTextField("Company Name"),
          const SizedBox(height: 10),
          _buildTextField("Work Location"),
          const SizedBox(height: 10),
          _buildPositionTypeSelection(),
          const SizedBox(height: 10),
          _buildExperienceLevelSelection(),
          const SizedBox(height: 10),
          _buildTextField("Salary (in Birr)", isNumeric: true),
          const SizedBox(height: 10),
          _buildTextField("Application Deadline", isDate: true),
          const SizedBox(height: 10),
          _buildTextField("Job Description", maxLines: 5),
          const SizedBox(height: 10),
          _buildTextField("Job Requirement", maxLines: 5),
        ],
      ),
    );
  }

  Widget _buildPositionTypeSelection() {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select Position Type"),
      items: positionTypes.map((String type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) => setState(() => selectedPositionType = value),
      validator: (value) =>
          value == null ? 'Please select a position type' : null,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
      onSaved: (value) => selectedPositionType = value,
    );
  }

  Widget _buildExperienceLevelSelection() {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      decoration: _inputDecoration("Select Experience Level"),
      items: experienceLevels.map((String level) {
        return DropdownMenuItem(value: level, child: Text(level));
      }).toList(),
      onChanged: (value) => setState(() => selectedExperienceLevel = value),
      validator: (value) =>
          value == null ? 'Please select an experience level' : null,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
      onSaved: (value) => selectedExperienceLevel = value,
    );
  }

  Widget _buildTextField(String label,
      {int maxLines = 1, bool isNumeric = false, bool isDate = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller:
            label == "Application Deadline" ? _deadlineController : null,
        decoration: _inputDecoration(label, isDate: isDate), // Pass isDate flag
        maxLines: maxLines,
        readOnly: isDate,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
        onTap: () async {
          if (isDate) {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              String formattedDate = "${pickedDate.toLocal()}".split(' ')[0];
              setState(() {
                applicationDeadline = formattedDate;
                _deadlineController.text = formattedDate;
              });
            }
          }
        },
        onChanged: (value) {
          if (label == "Name") {
            name = value;
          } else if (label == "Company Name") {
            companyName = value;
          } else if (label == "Position Title") {
            positionTitle = value;
          } else if (label == "Work Location") {
            workLocation = value;
          } else if (label == "Salary (in Birr)") {
            salary = value;
          } else if (label == "Job Description") {
            jobDescription = value;
          } else if (label == "Job Requirement") {
            jobRequirement = value;
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
        onSaved: (value) {
          if (label == "Name") {
            name = value ?? '';
          } else if (label == "Company Name") {
            companyName = value ?? '';
          } else if (label == "Position Title") {
            positionTitle = value ?? '';
          } else if (label == "Work Location") {
            workLocation = value ?? '';
          } else if (label == "Salary (in Birr)") {
            salary = value ?? '';
          } else if (label == "Application Deadline") {
            applicationDeadline = value ?? '';
          } else if (label == "Job Description") {
            jobDescription = value ?? '';
          } else if (label == "Job Requirement") {
            jobRequirement = value ?? '';
          }
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {bool isDate = false}) {
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
      suffixIcon: isDate
          ? const Icon(Icons.calendar_today, color: Colors.blue) // Calendar icon
          : null,
    );
  }
}

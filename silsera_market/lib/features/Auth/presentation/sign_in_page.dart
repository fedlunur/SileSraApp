import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import 'package:silesra/features/Auth/presentation/block/user_bloc.dart';
import 'package:silesra/features/Auth/presentation/block/user_event.dart';
import 'package:silesra/features/Auth/presentation/block/user_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  String? validatePhoneNumber(PhoneNumber? phoneNumber) {
    // If phoneNumber is null or empty
    if (phoneNumber == null || phoneNumber.number.isEmpty) {
      return 'Phone number cannot be empty';
    }

    // Optionally, you can check for 10-digit phone number length (or any other validation)
    if (phoneNumber.number.length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }

    return null; // Return null if valid
  }

  // String? validatePhoneNumber(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter phone number';
  //   }
  //   if (!RegExp(r'^\d{10}$').hasMatch(value)) {
  //     return 'Enter a valid 10-digit phone number';
  //   }
  //   return null;
  // }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 2) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            // Navigate to home screen after successful login
            context.go('/home');
          } else if (state is UserError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SvgPicture.asset(
                        'assets/logo2.svg',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      "Welcome to ስለ ስራ!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF168AE3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                IntlPhoneField(
                  controller: phoneController,
                  decoration: _inputDecoration('Phone Number').copyWith(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    isDense: true, // Reduces height and internal spacing
                  ),

                  initialCountryCode: 'ET',
                  validator: validatePhoneNumber,
                  style: const TextStyle(color: Colors.black),
                  dropdownIconPosition:
                      IconPosition.trailing, // Moves the dropdown closer
                  textAlignVertical:
                      TextAlignVertical.center, // Aligns text properly
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: _inputDecoration('Password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[850],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  obscureText: _obscurePassword, // Updated to use state
                  validator: validatePassword,
                ),
                const SizedBox(height: 24),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is UserLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                // Dispatch the SignIn event
                                context.read<UserBloc>().add(
                                      SignIn(
                                        phone: phoneController.text,
                                        password: passwordController.text,
                                      ),
                                    );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF168AE3),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state is UserLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'Sign In',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color.fromRGBO(136, 136, 136, 1),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/sign_up');
                      },
                      child: Text(
                        'Sign Up.',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF168AE3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

  @override
  void dispose() {
    // Your cleanup logic here (e.g., closing streams, controllers, etc.)
    super.dispose(); // Always call super.dispose()
  }
}

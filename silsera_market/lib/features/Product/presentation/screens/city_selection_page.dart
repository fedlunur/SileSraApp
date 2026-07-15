import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:silesra/core/config/settings.dart';

class CitySelectionPage extends StatefulWidget {
  const CitySelectionPage({super.key});

  @override
  _CitySelectionPageState createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  String? selectedCity;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (extra != null && extra.containsKey('selectedcity')) {
      selectedCity = extra['selectedcity'] as String?;
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black87, fontSize: 16),
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

  void _checkLocation() async {
    if (selectedCity == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      GoRouter.of(context).go('/add?city=$selectedCity');

      // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) {
      //   _showErrorDialog("Please enable location services.");
      //   await Geolocator.openLocationSettings();
      //   setState(() => isLoading = false);
      //   return;
      // }

      // LocationPermission permission = await Geolocator.requestPermission();
      // permission = await Geolocator.checkPermission();
      // if (permission == LocationPermission.denied) {
      //   _showErrorDialog("Location permission denied.");
      //   setState(() => isLoading = false);
      //   return;
      // }
      // if (permission == LocationPermission.deniedForever) {
      //   _showErrorDialog("Location permission permanently denied.");
      //   setState(() => isLoading = false);
      //   return;
      // }

      // // Set timeout to avoid long waiting time
      // Position position = await Geolocator.getCurrentPosition(
      //   locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      // ).timeout(Duration(seconds: 3), onTimeout: () {
      //   throw TimeoutException("Location fetch timed out.");
      // });

      // debugPrint("User Location: ${position.latitude}, ${position.longitude}");

      // Navigate with selected city
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("Failed to fetch location. Try again.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error", style: TextStyle(color: Colors.redAccent)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Color(0xFF168AE3))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your City'),
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
          onPressed: () =>
              context.go('/home', extra: {'selectedcity': selectedCity}),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF8FCFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: _inputDecoration("Select a city").copyWith(
                  fillColor: Colors.white,
                  filled: true,
                ),
                value: selectedCity,
                hint: const Text(
                  "Select a city",
                  style: TextStyle(color: Colors.black),
                ),
                dropdownColor: Colors.white,
                iconEnabledColor: Colors.black,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue;
                  });
                },
                items: cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(
                      city,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF168AE3))
                  : ElevatedButton(
                      onPressed: selectedCity == null ? null : _checkLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF168AE3),
                      ),
                      child: Text("Verify City"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

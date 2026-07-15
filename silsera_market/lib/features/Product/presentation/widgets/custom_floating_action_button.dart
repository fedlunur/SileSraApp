import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF168AE3),
      onPressed: onPressed,
      shape: const CircleBorder(),
      child: const Icon(Icons.camera_alt, color: Colors.white),
    );
  }
}
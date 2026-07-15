import 'package:flutter/material.dart';

class SegmentedInput extends StatelessWidget {
  final TextEditingController firstController;

  final String firstHint;
  final double width;
  const SegmentedInput({
    super.key,
    required this.firstController,
    this.firstHint = "First",
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border:
            Border.all(color: const Color.fromRGBO(22, 138, 227, 0.4), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: firstController,
        textAlign: TextAlign.justify,
        decoration: InputDecoration(
          hintText: firstHint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

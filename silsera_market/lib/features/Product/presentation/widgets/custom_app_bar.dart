import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String name;

  const CustomAppBar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(23, 138, 227, 1)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomElement extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color? color;
  final String route;

  const CustomElement(
      {super.key,
      required this.name,
      required this.icon,
      required this.color,
      required this.route});

  @override
  Widget build(BuildContext context) {
    final String newRoute = route;
    return Container(
      height: 119,
      width: 144,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => GoRouter.of(context).push(newRoute),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white.withOpacity(0.8),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Icon(icon, color: color, size: 24.0),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

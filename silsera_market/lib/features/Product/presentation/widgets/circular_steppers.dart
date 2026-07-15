import 'package:flutter/material.dart';

class StepperWidget extends StatelessWidget {
  final int activeStep;
  final int totalSteps;

  const StepperWidget({
    super.key,
    required this.activeStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        bool isActive = index == activeStep;
        return Row(
          children: [
            if (index != 0) // Add a connecting line
              Container(
                width: 30,
                height: 2,
                color: Colors.lightBlueAccent,
              ),
            CircleAvatar(
              radius: 30,
              backgroundColor:
                  isActive ? const Color(0xFF168AE3) : Colors.blue[100],
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.blue[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

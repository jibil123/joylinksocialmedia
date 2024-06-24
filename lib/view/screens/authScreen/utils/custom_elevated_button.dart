import 'package:flutter/material.dart';
import 'package:joylink/utils/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.icon});
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        onPressed();
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.whiteColor,
          backgroundColor: AppColors.primaryColor),
    );
  }
}

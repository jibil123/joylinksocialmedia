import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final int maxLines;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final IconData? suffixIconData;
  final VoidCallback? onSuffixIconPressed;

  const CustomTextField(
      {super.key,
      this.maxLines = 1,
      required this.hintText,
      this.obscureText = false,
      required this.controller,
      required this.validator,
      this.onSuffixIconPressed,
      this.suffixIconData});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 188, 176, 176),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: suffixIconData != null
              ? IconButton(
                  onPressed:onSuffixIconPressed ,
                  icon: Icon(suffixIconData))
              : null),
      validator: validator,
    );
  }
}

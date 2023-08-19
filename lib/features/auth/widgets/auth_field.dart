import 'package:flutter/material.dart';
import 'package:fwitter/theme/theme.dart';

class AuthField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final bool obscureText;
  final TextInputType textInputType;
  const AuthField({
    super.key,
    required this.textEditingController,
    required this.label,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.blueColor,
            width: 4,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.greyColor,
            width: 2,
          ),
        ),
        focusColor: Pallete.blueColor,
        contentPadding: const EdgeInsets.all(25),
        label: Text(label),
        labelStyle: const TextStyle(fontSize: 20),
      ),
      obscureText: obscureText,
      keyboardType: textInputType,
    );
  }
}

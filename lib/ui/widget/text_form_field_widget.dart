import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String textLabel;
  final String errorMessage;
  final IconButton? iconButton;
  final bool obscureText;

   const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.textLabel,
    required this.errorMessage,
    this.iconButton,
     required this.obscureText,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          obscureText: obscureText,
          validator: (value) {
            if (value!.isEmpty) {
              return errorMessage;
            }
            return null;
          },
          controller: controller,
          decoration: InputDecoration(
            labelText: textLabel,
            suffixIcon: iconButton,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

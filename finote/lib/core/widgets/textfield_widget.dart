import 'package:flutter/material.dart';

class FormFieldWidget extends StatelessWidget {
   final TextEditingController controller;
   final String hint;
   final IconData icon;
   final bool obscureText;
   final TextInputType keyboardType = TextInputType.text;
   final String? Function(String?)? validator;
  const FormFieldWidget({super.key,required this.controller,required this.hint,required this.icon,required this.obscureText,this.validator, required TextInputType keyboardType});

  @override
  Widget build(BuildContext context) {
  return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}
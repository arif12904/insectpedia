import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insectpedia/themes/insectpedia_colors.dart';
import '../provider/theme_provider.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? labelColor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.borderColor,
    this.focusedBorderColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    final effectiveBorderColor = borderColor ?? InsectpediaColors.textfieldColor;
    final effectiveFocusedColor = focusedBorderColor ?? themeProvider.secondary;
    final effectiveLabelColor = labelColor ?? InsectpediaColors.text2Color;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: effectiveLabelColor),
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: effectiveLabelColor) : null,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: effectiveBorderColor, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: effectiveFocusedColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}

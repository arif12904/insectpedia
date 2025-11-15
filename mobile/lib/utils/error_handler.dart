import 'package:flutter/material.dart';

class ErrorHandler {
  /// Menampilkan snackbar error
  static void showError(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      backgroundColor: Colors.red,
    );
  }

  /// Menampilkan snackbar sukses
  static void showSuccess(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
    );
  }

  static void _showCustomSnackBar(
      BuildContext context,
      String message, {
        required Color backgroundColor,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
        backgroundColor: backgroundColor,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

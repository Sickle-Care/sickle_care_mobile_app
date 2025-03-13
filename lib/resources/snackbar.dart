import 'package:flutter/material.dart';

void showErrorSnackbar(String errorMessage, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

void showSuccessSnackbar(String errorMessage, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage),
      backgroundColor: const Color.fromARGB(255, 0, 200, 83),
    ),
  );
}

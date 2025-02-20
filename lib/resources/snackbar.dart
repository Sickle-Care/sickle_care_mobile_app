import 'package:flutter/material.dart';

void showErrorSnackbar(String errorMessage, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

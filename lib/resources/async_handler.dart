import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncHandler<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue; // Use AsyncValue to handle loading and error states
  final Widget Function(BuildContext, T) onData; // Widget to display when data is available

  const AsyncHandler({
    super.key,
    required this.asyncValue,
    required this.onData,
  });

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: (data) => onData(context, data), // Pass the data to the onData callback
      loading: () => const Center(child: CircularProgressIndicator()), // Loading state
      error: (error, stackTrace) => Center(
        child: Text(
          "Error: $error", // Display the error message
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
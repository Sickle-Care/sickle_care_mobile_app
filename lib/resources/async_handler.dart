import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncHandler<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue; 
  final Widget Function(BuildContext, T) onData;

  const AsyncHandler({
    super.key,
    required this.asyncValue,
    required this.onData,
  });

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: (data) => onData(context, data), 
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          "Error: $error", 
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
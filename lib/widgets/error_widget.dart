import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorWidgetCustom({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onRetry,
            child: Text("Retry"),
          )
        ],
      ),
    );
  }
}

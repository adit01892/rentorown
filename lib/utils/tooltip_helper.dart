import 'package:flutter/material.dart';

/// A reusable info tooltip icon used across input forms and sliders.
Widget buildInfoTooltip(String message) {
  return Tooltip(
    message: message,
    preferBelow: false,
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.symmetric(horizontal: 16),
    showDuration: const Duration(seconds: 4),
    textStyle: const TextStyle(color: Colors.white, fontSize: 13),
    decoration: BoxDecoration(
      color: Colors.grey[800],
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.help_outline, size: 16, color: Colors.grey),
  );
}

import 'package:flutter/material.dart';

/// ## LastResultCard
/// A stateless widget that displays the most recent result in a styled container.
/// It is designed to highlight the last result with a green-themed card.
///
/// ### Properties
/// - `lastResult`: A string representing the most recent result to display.
///
/// ### Methods
/// - `build(BuildContext context)`: Builds a container with padding, border, and
///   rounded corners, containing a `Text` widget showing the last result.



class LastResultCard extends StatelessWidget {
  final String lastResult;

  const LastResultCard({super.key, required this.lastResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.lightGreen, width: 1),
      ),
      child: Text(
        "Last Result: $lastResult",
        style: TextStyle(color: Colors.green.shade800),
      ),
    );
  }
}

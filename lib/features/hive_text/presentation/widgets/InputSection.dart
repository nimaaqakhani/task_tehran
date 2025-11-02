import 'package:flutter/material.dart';

/// ## InputSection
/// A stateless widget that provides a user input area with a text field
/// and an "Analyze" button. This section is typically used to collect
/// text input from the user and trigger an analysis action.
///
/// ### Properties
/// - `controller`: A `TextEditingController` to manage the text input.
/// - `onAnalyze`: A callback function triggered when the "Analyze" button is pressed.
///
/// ### Methods
/// - `build(BuildContext context)`: Builds a column containing a styled `TextField`
///   and an `ElevatedButton` with an analytics icon.




class InputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAnalyze;

  const InputSection({
    super.key,
    required this.controller,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "متن را وارد کنید",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onAnalyze,
          icon: const Icon(Icons.analytics),
          label: const Text("آنالیز"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

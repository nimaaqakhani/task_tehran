import 'package:flutter/material.dart';

/// ## SearchSection
/// A stateless widget that provides a search input field for filtering history or other data.
/// It includes a search icon and supports focus management through a `FocusNode`.
///
/// ### Properties
/// - `controller`: A `TextEditingController` to manage the text input.
/// - `focusNode`: A `FocusNode` to handle focus and keyboard interactions.
///
/// ### Methods
/// - `build(BuildContext context)`: Builds a styled `TextField` with a search icon,
///   rounded borders, and a white background.


class SearchSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const SearchSection({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        labelText: "جستجو در تاریخچه",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

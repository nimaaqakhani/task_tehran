import 'package:flutter/material.dart';
import '../../data/model/history_item.dart';

/// ## HistoryList
/// A stateless widget that displays a scrollable list of `HistoryItem` objects
/// in a card format with options to edit or delete each item.
///
/// This widget is typically used to show the history of user inputs or actions
/// and allows interaction through callbacks.
///
/// ### Properties
/// - `items`: A list of `HistoryItem` objects to display.
/// - `onEdit`: Callback function triggered when the edit icon is pressed. Receives the `HistoryItem` to edit.
/// - `onDelete`: Callback function triggered when the delete icon is pressed. Receives the key of the item to delete.
///
/// ### Methods
/// - `build(BuildContext context)`: Builds a `ListView` of cards, each containing the text and key of a `HistoryItem`,
///   along with edit and delete buttons.



class HistoryList extends StatelessWidget {
  final List<HistoryItem> items;
  final void Function(HistoryItem) onEdit;
  final void Function(dynamic) onDelete;

  const HistoryList({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: ValueKey(items.length),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 3,
          child: ListTile(
            title: Text(
              item.text,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "Key: ${item.key}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Wrap(
              spacing: 8,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => onEdit(item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(item.key),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

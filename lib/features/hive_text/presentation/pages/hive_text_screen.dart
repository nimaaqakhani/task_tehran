import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/hive_text/presentation/widgets/HistoryList.dart';
import 'package:flutter_application_1/features/hive_text/presentation/widgets/InputSection.dart';
import 'package:flutter_application_1/features/hive_text/presentation/widgets/LastResultCard.dart';
import 'package:flutter_application_1/features/hive_text/presentation/widgets/SearchSection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/hive_text_bloc.dart';
import '../bloc/hive_text_event.dart';
import '../bloc/hive_text_state.dart';
import '../../data/model/history_item.dart';

/// ## HiveTextScreen
/// A stateful widget that serves as the main screen for the Hive + Analyzer CRUD feature.
/// It allows users to input text, analyze it, view the last result, and manage a history
/// of analyzed texts with edit, delete, and search capabilities.
///
/// This screen integrates with `HiveTextBloc` for state management and performs
/// the following functionalities:
/// - Displays an input section for text analysis (`InputSection`)
/// - Shows the last analysis result (`LastResultCard`)
/// - Provides a search field to filter history (`SearchSection`)
/// - Displays a list of historical items with edit and delete options (`HistoryList`)
/// - Supports clearing the entire history
///
/// ### Properties
/// - `_controller`: A `TextEditingController` for the main input field.
/// - `_searchController`: A `TextEditingController` for the search input.
/// - `_searchFocus`: A `FocusNode` to manage focus for the search field.
///
/// ### Methods
/// - `initState()`: Fetches initial history and sets up search listener.
/// - `dispose()`: Cleans up controllers and focus nodes.
/// - `_showEditDialog(HistoryItem item)`: Shows a dialog to edit a history item and updates the state.
/// - `build(BuildContext context)`: Builds the widget tree, including input, last result, search,
///   and history list sections with conditional rendering based on state.


class HiveTextScreen extends StatefulWidget {
  const HiveTextScreen({super.key});

  @override
  State<HiveTextScreen> createState() => _HiveTextScreenState();
}

class _HiveTextScreenState extends State<HiveTextScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<HiveTextBloc>().add(FetchHistoryEvent());
    _searchController.addListener(() {
      context.read<HiveTextBloc>().add(SearchQueryChangedEvent(_searchController.text.trim()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _showEditDialog(HistoryItem item) async {
    final editController = TextEditingController(text: item.text);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('ویرایش آیتم'),
          content: TextField(controller: editController, decoration: const InputDecoration(labelText: 'متن جدید')),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('انصراف')),
            ElevatedButton(
              onPressed: () {
                final newText = editController.text.trim();
                if (newText.isEmpty) return;
                context.read<HiveTextBloc>().add(UpdateItemEvent(item.key, newText));
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('آیتم با موفقیت ویرایش شد')));
              },
              child: const Text('ذخیره'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Hive + Analyzer CRUD"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              context.read<HiveTextBloc>().add(ClearHistoryEvent());
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمام تاریخچه حذف شد')));
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocBuilder<HiveTextBloc, HiveTextState>(
          builder: (context, state) {
            final filteredResults = state.filteredHistory.reversed.toList();
            final bool isHistoryEmpty = filteredResults.isEmpty && state.searchQuery.isEmpty;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputSection(
                      controller: _controller,
                      onAnalyze: () {
                        final text = _controller.text.trim();
                        if (text.isEmpty) return;
                        context.read<HiveTextBloc>().add(AnalyzeInputEvent(text));
                        _controller.clear();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('متن با موفقیت آنالیز شد')));
                      },
                    ),
                    const SizedBox(height: 16),
                    if (state.lastResult.isNotEmpty) LastResultCard(lastResult: state.lastResult),
                    const SizedBox(height: 16),
                    if (!isHistoryEmpty || state.searchQuery.isNotEmpty)
                      SearchSection(controller: _searchController, focusNode: _searchFocus),
                    const SizedBox(height: 16),
                    if (!isHistoryEmpty)
                      HistoryList(
                        items: filteredResults,
                        onEdit: _showEditDialog,
                        onDelete: (key) {
                          context.read<HiveTextBloc>().add(DeleteItemEvent(key));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('آیتم حذف شد')));
                        },
                      ),
                    if (isHistoryEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Center(
                          child: Text(
                            "تاکنون متنی ذخیره نشده است.\nابتدا متنی وارد و آنالیز کنید.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

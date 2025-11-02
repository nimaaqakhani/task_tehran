import 'package:equatable/equatable.dart';

/// ## HiveTextEvent
/// An abstract class representing all possible events for the HiveText feature
/// in the Bloc architecture. Events are used to trigger state changes in the
/// `HiveTextBloc`.
///
/// ### Events
/// - `FetchHistoryEvent`: Requests loading of all stored history items.
/// - `AnalyzeInputEvent`: Triggers analysis of a given text input.
///   - `text`: The input text to analyze.
/// - `UpdateItemEvent`: Updates an existing history item with new text.
///   - `key`: The unique identifier of the item to update.
///   - `newText`: The new text to replace the existing value.
/// - `DeleteItemEvent`: Deletes a history item by its key.
///   - `key`: The unique identifier of the item to delete.
/// - `ClearHistoryEvent`: Clears all history items.
/// - `SearchQueryChangedEvent`: Updates the search query used to filter the history.
///   - `query`: The new search query string.


abstract class HiveTextEvent extends Equatable {
  const HiveTextEvent();
  @override
  List<Object?> get props => [];
}

class FetchHistoryEvent extends HiveTextEvent {}

class AnalyzeInputEvent extends HiveTextEvent {
  final String text;
  const AnalyzeInputEvent(this.text);
  @override
  List<Object?> get props => [text];
}

class UpdateItemEvent extends HiveTextEvent {
  final dynamic key;
  final String newText;
  const UpdateItemEvent(this.key, this.newText);
  @override
  List<Object?> get props => [key, newText];
}

class DeleteItemEvent extends HiveTextEvent {
  final dynamic key;
  const DeleteItemEvent(this.key);
  @override
  List<Object?> get props => [key];
}

class ClearHistoryEvent extends HiveTextEvent {}

class SearchQueryChangedEvent extends HiveTextEvent {
  final String query;
  const SearchQueryChangedEvent(this.query);
  @override
  List<Object?> get props => [query];
}

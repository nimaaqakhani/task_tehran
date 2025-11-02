
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/hive_text/data/model/history_item.dart';

/// ## HiveTextState
/// Represents the state of the HiveText feature in the application. It holds
/// the full history of analyzed texts, the filtered history based on the search
/// query, the current search query, and the last analyzed result.
///
/// This state class is immutable and extends `Equatable` for efficient state
/// comparison in Bloc.
///
/// ### Properties
/// - `history`: A list of all `HistoryItem` objects stored in Hive.
/// - `filteredHistory`: A list of `HistoryItem` objects filtered according to the current search query.
/// - `searchQuery`: The current search text used to filter the history.
/// - `lastResult`: The last analyzed text result.
///
/// ### Methods
/// - `copyWith({history, filteredHistory, searchQuery, lastResult})`: Returns
///   a new `HiveTextState` instance with updated fields while keeping other


class HiveTextState extends Equatable {
  final List<HistoryItem> history;
  final List<HistoryItem> filteredHistory;
  final String searchQuery;
  final String lastResult;

  const HiveTextState({
    required this.history,
    required this.filteredHistory,
    required this.searchQuery,
    required this.lastResult,
  });

  @override
  List<Object> get props => [history, filteredHistory, searchQuery, lastResult];

  HiveTextState copyWith({
    List<HistoryItem>? history,
    List<HistoryItem>? filteredHistory,
    String? searchQuery,
    String? lastResult,
  }) {
    return HiveTextState(
      history: history ?? this.history,
      filteredHistory: filteredHistory ?? this.filteredHistory,
      searchQuery: searchQuery ?? this.searchQuery,
      lastResult: lastResult ?? this.lastResult,
    );
  }
}
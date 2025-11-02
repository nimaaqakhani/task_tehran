import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/hive_text/data/model/history_item.dart'; 
import 'hive_text_event.dart';
import 'hive_text_state.dart';
import '../../data/repository/hive_repository_impl.dart';
import '../../domain/usecases/analyze_input.dart'; 
import '../../domain/usecases/clear_history.dart'; 

/// ## HiveTextBloc
/// A Bloc class that manages the state and events for the HiveText feature.
/// It handles text input analysis, history management, and search functionality.
///
/// ### Responsibilities
/// - Fetching all stored history items from `HiveRepositoryImpl`.
/// - Analyzing text input using the `AnalyzeInput` use case.
/// - Updating, deleting, and clearing history items.
/// - Filtering history items based on the search query.
///
/// ### Dependencies
/// - `_repository`: An instance of `HiveRepositoryImpl` for CRUD operations on Hive.
/// - `_analyzeInputUseCase`: An instance of `AnalyzeInput` for performing text analysis.
/// - `_clearHistoryUseCase`: An instance of `ClearHistory` to clear all stored history.
///
/// ### Events Handled
/// - `FetchHistoryEvent`: Loads all history items and updates state.
/// - `AnalyzeInputEvent`: Analyzes the provided text and updates the last result.
/// - `UpdateItemEvent`: Updates a specific history item in the repository.
/// - `DeleteItemEvent`: Deletes a specific history item from the repository.
/// - `ClearHistoryEvent`: Clears all history items and resets state.
/// - `SearchQueryChangedEvent`: Filters history items based on the current search query.
///
/// ### Methods
/// - `_onFetchHistory(FetchHistoryEvent, Emitter<HiveTextState>)`: Handles fetching all history items.
/// - `_onAnalyzeInput(AnalyzeInputEvent, Emitter<HiveTextState>)`: Handles analyzing input text.
/// - `_onUpdateItem(UpdateItemEvent, Emitter<HiveTextState>)`: Handles updating a specific history item.
/// - `_onDeleteItem(DeleteItemEvent, Emitter<HiveTextState>)`: Handles deleting a specific history item.
/// - `_onClearHistory(ClearHistoryEvent, Emitter<HiveTextState>)`: Handles clearing the entire history.
/// - `_onSearchQueryChanged(SearchQueryChangedEvent, Emitter<HiveTextState>)`: Handles filtering history based on search query.



class HiveTextBloc extends Bloc<HiveTextEvent, HiveTextState> {
  final HiveRepositoryImpl _repository;
  final AnalyzeInput _analyzeInputUseCase;
  final ClearHistory _clearHistoryUseCase;

  HiveTextBloc({
    required HiveRepositoryImpl repository,
    required AnalyzeInput analyzeInputUseCase,
    required ClearHistory clearHistoryUseCase,
  })  : _repository = repository,
        _analyzeInputUseCase = analyzeInputUseCase,
        _clearHistoryUseCase = clearHistoryUseCase,
        super(const HiveTextState(
          history: [],
          filteredHistory: [],
          searchQuery: '',
          lastResult: '',
        )) {
    on<FetchHistoryEvent>(_onFetchHistory);
    on<AnalyzeInputEvent>(_onAnalyzeInput);
    on<ClearHistoryEvent>(_onClearHistory);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<UpdateItemEvent>(_onUpdateItem);
    on<DeleteItemEvent>(_onDeleteItem);

    add(FetchHistoryEvent());
  }

  Future<void> _onFetchHistory(
      FetchHistoryEvent event, Emitter<HiveTextState> emit) async {
    final List<HistoryItem> allItems = _repository.getAllResultsWithKeys();
    emit(state.copyWith(
      history: allItems,
      filteredHistory: allItems,
    ));
    add(SearchQueryChangedEvent(state.searchQuery));
  }

  Future<void> _onAnalyzeInput(
      AnalyzeInputEvent event, Emitter<HiveTextState> emit) async {
    final text = event.text.trim();
    if (text.isNotEmpty) {
      final result = await _analyzeInputUseCase.call(text);
      emit(state.copyWith(lastResult: result));
      add(FetchHistoryEvent());
    }
  }

  Future<void> _onUpdateItem(
      UpdateItemEvent event, Emitter<HiveTextState> emit) async {
    await _repository.updateItemAtKey(event.key, event.newText.trim());
    add(FetchHistoryEvent());
  }

  Future<void> _onDeleteItem(
      DeleteItemEvent event, Emitter<HiveTextState> emit) async {
    await _repository.deleteItemAtKey(event.key);
    add(FetchHistoryEvent());
  }

  Future<void> _onClearHistory(
      ClearHistoryEvent event, Emitter<HiveTextState> emit) async {
    await _clearHistoryUseCase.call();
    emit(state.copyWith(
      lastResult: '',
      searchQuery: '',
      history: const [],
      filteredHistory: const [],
    ));
  }

  void _onSearchQueryChanged(
      SearchQueryChangedEvent event, Emitter<HiveTextState> emit) {
    final newSearchQuery = event.query.trim();
    final filteredResults = state.history
        .where((item) =>
            item.text.toLowerCase().contains(newSearchQuery.toLowerCase()))
        .toList();

    emit(state.copyWith(
      searchQuery: newSearchQuery,
      filteredHistory: filteredResults,
    ));
  }
}

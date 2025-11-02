import 'package:hive_flutter/hive_flutter.dart';
import '../model/history_item.dart';

/// ## HiveRepositoryImpl
/// A repository class that provides CRUD operations for storing and managing
/// historical text input in a Hive database. This class serves as the data
/// layer for the HiveText feature.
///
/// ### Properties
/// - `boxName`: The name of the Hive box used to store history items (`historyBox`).
/// - `_box`: The Hive box instance used for data storage (initialized in `init`).
///
/// ### Methods
/// - `init()`: Opens the Hive box for storing history items. Must be called before using the repository.
/// - `addResult(String text)`: Adds a new text entry to the Hive box.
/// - `getAllResultsWithKeys()`: Retrieves all stored items as a list of `HistoryItem` objects, including their keys.
/// - `deleteItemAtKey(dynamic key)`: Deletes a specific item from the Hive box by its key.
/// - `clearAll()`: Clears all items from the Hive box.
/// - `updateItemAtKey(dynamic key, String newText)`: Updates an existing item in the Hive box with new text.


class HiveRepositoryImpl {
  static const String boxName = 'historyBox';
  static Box? _box;
  HiveRepositoryImpl();
  static Future<void> init() async {
    _box = await Hive.openBox(boxName);
  }
  Future<void> addResult(String text) async {
    await _box?.add(text);
  }
  List<HistoryItem> getAllResultsWithKeys() {
    if (_box == null) return [];
    return _box!.keys.map((key) {
      final value = _box!.get(key);
      return HistoryItem(key: key, text: value.toString()); 
    }).toList();
  }

  Future<void> deleteItemAtKey(dynamic key) async {
    await _box?.delete(key);
  }
  Future<void> clearAll() async {
    await _box?.clear();
  }
  Future<void> updateItemAtKey(dynamic key, String newText) async {
    await _box?.put(key, newText);
  }
}

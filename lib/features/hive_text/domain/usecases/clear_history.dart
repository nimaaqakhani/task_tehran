import '../../data/repository/hive_repository_impl.dart';
/// ## ClearHistory
/// A use case class responsible for clearing all stored history items
/// from the Hive repository. This class encapsulates the action of
/// removing all data to maintain separation of concerns in the domain layer.
///
/// ### Properties
/// - `repository`: An instance of `HiveRepositoryImpl` used to perform
///   the actual data clearing operation.
///
/// ### Methods
/// - `call()`: Executes the use case by invoking the repository's `clearAll` method.


class ClearHistory {
  final HiveRepositoryImpl repository;

  ClearHistory(this.repository);

  Future<void> call() async {
    await repository.clearAll();
  }
}

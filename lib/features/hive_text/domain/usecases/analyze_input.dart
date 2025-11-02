import '../../../core/platform_channel.dart';
import '../../data/repository/hive_repository_impl.dart'; 

/// ## AnalyzeInput
/// A use case class responsible for analyzing a given text input using a
/// platform-specific channel and storing the input in the Hive repository.
///
/// This class separates the domain logic of text analysis from the UI layer,
/// ensuring clean architecture principles.
///
/// ### Properties
/// - `repository`: An instance of `HiveRepositoryImpl` used to store the input text.
///
/// ### Methods
/// - `call(String input)`: 
///   1. Sends the input text to a platform-specific channel for analysis (`PlatformChannel.invokeAnalyze`).
///   2. Stores the input text in the Hive repository.
///   3. Returns the analysis result as a `String`.


class AnalyzeInput {
  final HiveRepositoryImpl repository;

  AnalyzeInput(this.repository); 

  Future<String> call(String input) async {
    final analysisResult = await PlatformChannel.invokeAnalyze(input);
    await repository.addResult(input); 
    return analysisResult; 
  }
}
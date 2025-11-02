import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/notifications/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/hive_text/presentation/bloc/hive_text_bloc.dart';
import 'features/hive_text/presentation/pages/hive_text_screen.dart';
import 'features/hive_text/data/repository/hive_repository_impl.dart';
import 'features/hive_text/domain/usecases/analyze_input.dart';
import 'features/hive_text/domain/usecases/clear_history.dart';

/// ## MyApp
/// The root widget of the Flutter application. It initializes required services,
/// sets up dependency injection, and provides the main application structure.
///
/// Responsibilities include:
/// - Initializing Hive for local storage
/// - Initializing and starting the NotificationService
/// - Setting up repository and use case instances for the HiveText feature
/// - Providing the `HiveTextBloc` to the widget tree via `BlocProvider`
/// - Displaying the `HiveTextScreen` as the home screen
///
/// ### Properties
/// - `hiveRepository`: An instance of `HiveRepositoryImpl` used for data persistence
/// - `analyzeInputUseCase`: Use case for analyzing user input
/// - `clearHistoryUseCase`: Use case for clearing stored history
///
/// ### Methods
/// - `build(BuildContext context)`: Builds the widget tree and injects dependencies.




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveRepositoryImpl.init();
  await NotificationService.init();
  await NotificationService.startNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final HiveRepositoryImpl hiveRepository = HiveRepositoryImpl();
    final AnalyzeInput analyzeInputUseCase = AnalyzeInput(hiveRepository);
    final ClearHistory clearHistoryUseCase = ClearHistory(hiveRepository);

    return BlocProvider(
      create: (context) => HiveTextBloc(
        repository: hiveRepository,
        analyzeInputUseCase: analyzeInputUseCase,
        clearHistoryUseCase: clearHistoryUseCase,
      ),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HiveTextScreen(),
      ),
    );
  }
}

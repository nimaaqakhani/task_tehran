import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/core/widgets/WelcomeScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'features/hive_text/presentation/bloc/hive_text_bloc.dart';
import 'features/hive_text/data/repository/hive_repository_impl.dart';
import 'features/hive_text/domain/usecases/analyze_input.dart';
import 'features/hive_text/domain/usecases/clear_history.dart';
import 'features/notifications/notification_service.dart';
import 'features/student_data/data/datasources/student_local_data_source.dart';
import 'features/student_data/data/repositories/student_repository_impl.dart';
import 'features/student_data/domain/usecases/add_student_usecase.dart';
import 'features/student_data/domain/usecases/get_all_students_usecase.dart';
import 'features/student_data/domain/usecases/delete_student_usecase.dart';
import 'features/student_data/domain/usecases/update_student_usecase.dart';

late final AddStudentUseCase addStudentUseCase;
late final GetAllStudentsUseCase getAllStudentsUseCase;
late final DeleteStudentUseCase deleteStudentUseCase;
late final UpdateStudentUseCase updateStudentUseCase;
late final HiveRepositoryImpl hiveRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
    await AndroidAlarmManager.initialize();
    await HiveRepositoryImpl.init();
    hiveRepository = HiveRepositoryImpl();

    final studentDataSource = StudentLocalDataSourceImpl();
    await studentDataSource.init();
    final studentRepository = StudentRepositoryImpl(studentDataSource);

    addStudentUseCase = AddStudentUseCase(studentRepository);
    getAllStudentsUseCase = GetAllStudentsUseCase(studentRepository);
    deleteStudentUseCase = DeleteStudentUseCase(studentRepository);
    updateStudentUseCase = UpdateStudentUseCase(studentRepository);

    await NotificationService.start();

    debugPrint("Main: All services initialized successfully");
  } catch (e, stack) {
    debugPrint("Main: Initialization error: $e\n$stack");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final analyzeInputUseCase = AnalyzeInput(hiveRepository);
    final clearHistoryUseCase = ClearHistory(hiveRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HiveTextBloc(
            repository: hiveRepository,
            analyzeInputUseCase: analyzeInputUseCase,
            clearHistoryUseCase: clearHistoryUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'برنامه چند ماژولی',
        home: WelcomeScreen(
          addStudent: addStudentUseCase,
          getAllStudents: getAllStudentsUseCase,
          deleteStudent: deleteStudentUseCase,
          updateStudent: updateStudentUseCase,
        ),
      ),
    );
  }
}

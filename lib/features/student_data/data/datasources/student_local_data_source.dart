import 'package:hive_flutter/hive_flutter.dart';
import '../models/student_model.dart';

abstract class StudentLocalDataSource {
  Future<void> init();
  Future<void> saveStudent(StudentModel student);
  List<StudentModel> getAllStudents();
  Future<void> deleteStudent(String id);
}

class StudentLocalDataSourceImpl implements StudentLocalDataSource {
  static const String _boxName = 'students_clean_box';
  late final Box<StudentModel> _box;

  @override
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(StudentModelAdapter().typeId)) {
      Hive.registerAdapter(StudentModelAdapter());
    }
    _box = await Hive.openBox<StudentModel>(_boxName);
  }

  @override
  Future<void> saveStudent(StudentModel student) async {
    await _box.put(student.id, student); 
  }

  @override
  List<StudentModel> getAllStudents() {
    return _box.values.toList();
  }

  @override
  Future<void> deleteStudent(String id) async {
    await _box.delete(id);
  }
}

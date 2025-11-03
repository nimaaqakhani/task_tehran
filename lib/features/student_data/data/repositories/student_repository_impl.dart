import 'package:flutter_application_1/features/student_data/data/datasources/student_local_data_source.dart';
import 'package:flutter_application_1/features/student_data/data/models/student_model.dart';
import 'package:flutter_application_1/features/student_data/domain/entities/student_entity.dart';
import 'package:flutter_application_1/features/student_data/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentLocalDataSource dataSource;

  StudentRepositoryImpl(this.dataSource);
  @override
  Future<void> addStudent(StudentEntity student) async {
    final model = StudentModel.fromEntity(student);
    await dataSource.saveStudent(model);
  }

  @override
  Future<List<StudentEntity>> getAllStudents() async {
    final models = dataSource.getAllStudents();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateStudent(StudentEntity student) async {
    final model = StudentModel.fromEntity(student);
    await dataSource.saveStudent(model);
  }

  @override
  Future<void> deleteStudent(String id) async {
    await dataSource.deleteStudent(id);
  }
}

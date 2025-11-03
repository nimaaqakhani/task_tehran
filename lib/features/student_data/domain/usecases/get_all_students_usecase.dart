import '../entities/student_entity.dart';
import '../repositories/student_repository.dart';

class GetAllStudentsUseCase {
  final StudentRepository repository;
  GetAllStudentsUseCase(this.repository);

  Future<List<StudentEntity>> call() async {
    return repository.getAllStudents();
  }
}
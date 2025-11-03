import '../entities/student_entity.dart';
import '../repositories/student_repository.dart';

class AddStudentUseCase {
  final StudentRepository repository;
  AddStudentUseCase(this.repository);

  Future<void> call(StudentEntity student) async {
    await repository.addStudent(student); 
  }
}
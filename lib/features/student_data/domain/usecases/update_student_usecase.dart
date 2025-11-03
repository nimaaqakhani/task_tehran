// domain/usecases/update_student_usecase.dart
import '../entities/student_entity.dart';
import '../repositories/student_repository.dart';

class UpdateStudentUseCase {
  final StudentRepository repository;
  UpdateStudentUseCase(this.repository);
  Future<void> call(StudentEntity student) async {
    await repository.updateStudent(student);
  }
}

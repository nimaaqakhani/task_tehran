import '../entities/student_entity.dart';

abstract class StudentRepository {
  Future<void> addStudent(StudentEntity student);
  Future<List<StudentEntity>> getAllStudents();
  Future<void> updateStudent(StudentEntity student);
  Future<void> deleteStudent(String id);
}

import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/student_entity.dart'; 
part 'student_model.g.dart'; 

@HiveType(typeId: 10) 
class StudentModel extends HiveObject {
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String name;
  
  @HiveField(2)
  late String major;
  
  @HiveField(3)
  late int score;

  StudentModel({
    required this.id,
    required this.name,
    required this.major,
    required this.score,
  });

  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      name: entity.name,
      major: entity.major,
      score: entity.score,
    );
  }
  
  StudentEntity toEntity() {
    return StudentEntity(
      id: id,
      name: name,
      major: major,
      score: score,
    );
  }
}
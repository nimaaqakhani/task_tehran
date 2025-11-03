import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/hive_text/presentation/pages/hive_text_screen.dart';
import 'package:flutter_application_1/features/student_data/domain/usecases/add_student_usecase.dart';
import 'package:flutter_application_1/features/student_data/domain/usecases/delete_student_usecase.dart';
import 'package:flutter_application_1/features/student_data/domain/usecases/get_all_students_usecase.dart';
import 'package:flutter_application_1/features/student_data/domain/usecases/update_student_usecase.dart'; // 🚨 ایمپورت جدید
import 'package:flutter_application_1/features/student_data/presentation/pages/student_list_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final AddStudentUseCase addStudent;
  final GetAllStudentsUseCase getAllStudents;
  final DeleteStudentUseCase deleteStudent;
  final UpdateStudentUseCase updateStudent;

  const WelcomeScreen({
    required this.addStudent,
    required this.getAllStudents,
    required this.deleteStudent,
    required this.updateStudent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'انتخاب ماژول',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'به برنامه خود خوش آمدید!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 40),

              _buildModuleButton(
                context,
                title: 'مدیریت اطلاعات دانشجویان',
                icon: Icons.school,
                color: const Color(0xFFE65100),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentListScreen(
                        addStudent: addStudent,
                        getAllStudents: getAllStudents,
                        deleteStudent: deleteStudent,
                        updateStudent: updateStudent,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              _buildModuleButton(
                context,
                title: 'ابزار یادآوری و متن',
                icon: Icons.notifications_active,
                color: const Color(0xFF0D47A1),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HiveTextScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 300,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}

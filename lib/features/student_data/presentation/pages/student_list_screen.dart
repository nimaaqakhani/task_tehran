import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/student_data/presentation/widgets/add_student_dialog.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/usecases/add_student_usecase.dart';
import '../../domain/usecases/delete_student_usecase.dart';
import '../../domain/usecases/get_all_students_usecase.dart';
import '../../domain/usecases/update_student_usecase.dart'; 
import '../widgets/student_card.dart'; 


class StudentListScreen extends StatefulWidget {
  final AddStudentUseCase addStudent;
  final GetAllStudentsUseCase getAllStudents;
  final DeleteStudentUseCase deleteStudent;
  final UpdateStudentUseCase updateStudent; 

  const StudentListScreen({
    required this.addStudent,
    required this.getAllStudents,
    required this.deleteStudent,
    required this.updateStudent, 
    super.key,
  });

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  Future<List<StudentEntity>>? _studentsFuture;

  @override
  void initState() {
    super.initState();
    _loadStudents(); 
  }
  
  void _loadStudents() {
    setState(() {
      _studentsFuture = widget.getAllStudents(); 
    });
  }

  void _deleteStudent(String id) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('دانشجو حذف شد.'),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ),
    );
    await widget.deleteStudent(id);
    _loadStudents(); 
  }

  void _showEditOrCreateDialog(StudentEntity? studentToEdit) {
    showDialog<StudentEntity>(
      context: context,
      builder: (context) => StudentFormDialog(studentToEdit: studentToEdit), 
    ).then((resultStudent) async {
      if (resultStudent != null) {
        if (studentToEdit == null) {
          await widget.addStudent(resultStudent);
        } else {
          await widget.updateStudent(resultStudent); 
        }
        _loadStudents(); 
      }
    });
  }
    void _showAddStudentDialog() {
    _showEditOrCreateDialog(null); 
  }
  void _showUpdateStudentDialog(StudentEntity student) {
    _showEditOrCreateDialog(student); 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت دانشجویان', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadStudents,
            tooltip: 'بارگیری مجدد',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddStudentDialog,
        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
        label: const Text('افزودن دانشجو', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFE65100), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder<List<StudentEntity>>(
          future: _studentsFuture,
          builder: (context, snapshot) {
            // ... (منطق Loading/Error/Empty) ...
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFFE65100)));
            }
            if (snapshot.hasError) {
              return Center(child: Text('خطای بارگیری داده: ${snapshot.error}', style: const TextStyle(color: Colors.red, fontSize: 16)));
            }
            
            final students = snapshot.data ?? [];
            
            if (students.isEmpty) {
               return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_alt_outlined, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    const Text('لیست دانشجویان خالی است.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return StudentCard(
                  student: student, 
                  onDelete: _deleteStudent,
                  onTap: () => _showUpdateStudentDialog(student), 
                ); 
              },
            );
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../domain/entities/student_entity.dart';

class StudentFormDialog extends StatefulWidget {
  final StudentEntity? studentToEdit; 

  const StudentFormDialog({this.studentToEdit, super.key});

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.studentToEdit != null) {
      final student = widget.studentToEdit!;
      _nameController.text = student.name;
      _majorController.text = student.major;
      _scoreController.text = student.score.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final isUpdating = widget.studentToEdit != null;
      
      final studentId = isUpdating 
          ? widget.studentToEdit!.id 
          : DateTime.now().millisecondsSinceEpoch.toString();

      final resultStudent = StudentEntity(
        id: studentId,
        name: _nameController.text.trim(),
        major: _majorController.text.trim().isEmpty
            ? 'نامشخص'
            : _majorController.text.trim(),
        score: int.tryParse(_scoreController.text.trim()) ?? 0,
      );
      
      Navigator.pop(context, resultStudent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating = widget.studentToEdit != null;
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(isUpdating ? 'ویرایش دانشجو' : 'افزودن دانشجوی جدید'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'نام'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'نام الزامی است' : null,
                ),
                TextFormField(
                  controller: _majorController,
                  decoration: const InputDecoration(labelText: 'رشته'),
                ),
                TextFormField(
                  controller: _scoreController,
                  decoration: const InputDecoration(labelText: 'معدل / امتیاز'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'معدل الزامی است';
                    if (int.tryParse(value!) == null) return 'عدد وارد کنید';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
            ),
            child: Text(
                isUpdating ? 'ذخیره تغییرات' : 'افزودن',
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
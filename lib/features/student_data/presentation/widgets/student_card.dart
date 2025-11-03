import 'package:flutter/material.dart';
import '../../domain/entities/student_entity.dart';

class StudentCard extends StatelessWidget {
  final StudentEntity student;
  final Function(String) onDelete;
  final VoidCallback? onTap;

  const StudentCard({
    required this.student,
    required this.onDelete,
    this.onTap, 
    super.key,
  });

  Color _getScoreColor(int score) {
    if (score > 17) {
      return Colors.green.shade700;
    } else if (score > 14) {
      return Colors.amber.shade700;
    } else {
      return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor(student.score);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF0D47A1).withValues(alpha: 0.1),
          child: const Icon(Icons.person, color: Color(0xFF0D47A1)),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'رشته: ${student.major}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  'معدل: ${student.score}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
          onPressed: () => onDelete(student.id),
          tooltip: 'حذف دانشجو',
        ),
      ),
    );
  }
}
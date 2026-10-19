import 'package:flutter/material.dart';
import 'package:mb_id_w10/models/student.dart';

class StudentListTile extends StatelessWidget {
  const StudentListTile({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${student.studentId} - ${student.fullName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.school, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text('สาขา: ${student.major}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.grade, size: 20, color: Colors.orange),
                const SizedBox(width: 8),
                Text('ชั้นปี: ${student.year}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

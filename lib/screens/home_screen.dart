import 'package:flutter/material.dart';
import 'package:mb_id_w10/database/student_database.dart';
import 'package:mb_id_w10/models/student.dart';
import 'package:mb_id_w10/screens/add_student_screen.dart';
import 'package:mb_id_w10/widgets/student_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<Student> students = [];

  Future<void> getAllStudents() async {
    setState(() => isLoading = true);

    students = await StudentDatabase.instance.readAllStudents();

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getAllStudents();
  }

  @override
  void dispose() {
    StudentDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildStudentsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddStudentScreen(),
            ),
          );

          getAllStudents();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStudentsList() {
    if (students.isEmpty) {
      return const Center(child: Text('ไม่มีข้อมูลนักศึกษา'));
    }
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];

        return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddStudentScreen(
                    student: student,
                  ),
                ),
              );

              getAllStudents();
            },
            child: StudentListTile(student: student));
      },
    );
  }
}


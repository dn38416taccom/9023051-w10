import 'package:flutter/material.dart';
import 'package:mb_id_w10/database/student_database.dart';
import 'package:mb_id_w10/models/student.dart';

final _formKey = GlobalKey<FormState>();

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({
    super.key,
    this.student,
  });

  final Student? student;

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  late final TextEditingController _studentIdController;
  late final TextEditingController _fullNameController;
  
  String _selectedMajor = 'วิทยาการคอมพิวเตอร์';
  final List<String> _majorOptions = [
    'วิทยาการคอมพิวเตอร์',
    'เทคโนโลยีสารสนเทศ',
    'ภูมิศาสตร์สารสนเทศ'
  ];

  String _selectedYear = '1';
  final List<String> _yearOptions = ['1', '2', '3', '4'];

  @override
  void initState() {
    _studentIdController = TextEditingController();
    _fullNameController = TextEditingController();
    if (widget.student != null) {
      _studentIdController.text = widget.student!.studentId;
      _fullNameController.text = widget.student!.fullName;
      _selectedMajor = widget.student!.major;
      _selectedYear = widget.student!.year;
    }
    super.initState();
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> addStudent() async {
    final student = Student(
      studentId: _studentIdController.text,
      fullName: _fullNameController.text,
      major: _selectedMajor,
      year: _selectedYear,
    );

    await StudentDatabase.instance.createStudent(student);
  }

  Future<void> updateStudent() async {
    final student = widget.student!.copy(
      studentId: _studentIdController.text,
      fullName: _fullNameController.text,
      major: _selectedMajor,
      year: _selectedYear,
    );

    await StudentDatabase.instance.updateStudent(student);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student != null ? 'Edit Student' : 'Add Student'),
        actions: [
          if (widget.student != null)
            IconButton(
              onPressed: () async {
                await StudentDatabase.instance.deleteStudent(widget.student!.id!);
                if (mounted) Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _studentIdController,
                decoration: const InputDecoration(
                  labelText: 'รหัสนักศึกษา',
                  hintText: 'กรอกรหัสนักศึกษา',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรหัสนักศึกษา';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อจริง-นามสกุล',
                  hintText: 'กรอกชื่อ-นามสกุล',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ-นามสกุล';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedMajor,
                decoration: const InputDecoration(labelText: 'สาขา'),
                items: _majorOptions.map((String major) {
                  return DropdownMenuItem<String>(
                    value: major,
                    child: Text(major),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMajor = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedYear,
                decoration: const InputDecoration(labelText: 'ชั้นปี'),
                items: _yearOptions.map((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedYear = newValue!;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: addUpdateStudent,
                child: Text(widget.student != null ? 'Update Student' : 'Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addUpdateStudent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final isUpdating = widget.student != null;

      if (isUpdating) {
        await updateStudent();
      } else {
        await addStudent();
      }

      if (mounted) Navigator.of(context).pop();
    }
  }
}

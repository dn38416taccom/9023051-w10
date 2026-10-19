import 'package:flutter/foundation.dart' show immutable;

const String studentsTable = 'students';

class StudentFields {
  static final List<String> values = [
    id,
    studentId,
    fullName,
    major,
    year,
  ];

  static const id = 'id';
  static const studentId = 'studentId';
  static const fullName = 'fullName';
  static const major = 'major';
  static const year = 'year';
}

@immutable
class Student {
  final int? id;
  final String studentId;
  final String fullName;
  final String major;
  final String year;

  const Student({
    this.id,
    required this.studentId,
    required this.fullName,
    required this.major,
    required this.year,
  });

  Student copy({
    int? id,
    String? studentId,
    String? fullName,
    String? major,
    String? year,
  }) =>
      Student(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        fullName: fullName ?? this.fullName,
        major: major ?? this.major,
        year: year ?? this.year,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      StudentFields.id: id,
      StudentFields.studentId: studentId,
      StudentFields.fullName: fullName,
      StudentFields.major: major,
      StudentFields.year: year,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map[StudentFields.id] != null ? map[StudentFields.id] as int : null,
      studentId: map[StudentFields.studentId] as String,
      fullName: map[StudentFields.fullName] as String,
      major: map[StudentFields.major] as String,
      year: map[StudentFields.year] as String,
    );
  }
}

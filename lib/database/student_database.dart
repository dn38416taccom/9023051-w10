import 'package:flutter/foundation.dart' show immutable;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '/models/student.dart';

@immutable
class StudentDatabase {
  static const String _databaseName = 'students.db';
  static const int _databaseVersion = 1;

  // Create a singleton
  const StudentDatabase._privateConstructor();
  static const StudentDatabase instance = StudentDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
    );
  }

  //! Create Database method
  Future _createDB(
    Database db,
    int version,
  ) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $studentsTable (
        ${StudentFields.id} $idType,
        ${StudentFields.studentId} $textType,
        ${StudentFields.fullName} $textType,
        ${StudentFields.major} $textType,
        ${StudentFields.year} $textType
      )
      ''');
  }

  //! C --> CRUD = Create
  Future<Student> createStudent(Student student) async {
    final db = await instance.database;
    final id = await db.insert(
      studentsTable,
      student.toMap(),
    );

    return student.copy(id: id);
  }

  //! R -- CURD = Read
  Future<Student> readStudent(int id) async {
    final db = await instance.database;

    final studentData = await db.query(
      studentsTable,
      columns: StudentFields.values,
      where: '${StudentFields.id} = ?',
      whereArgs: [id],
    );

    if (studentData.isNotEmpty) {
      return Student.fromMap(studentData.first);
    } else {
      throw Exception('Could not find a student with the given ID');
    }
  }

  // Get All Students
  Future<List<Student>> readAllStudents() async {
    final db = await instance.database;

    // Order by student id for better organization
    final result =
        await db.query(studentsTable, orderBy: '${StudentFields.studentId} ASC');

    return result.map((data) => Student.fromMap(data)).toList();
  }

  //! U --> CRUD = Update
  Future<int> updateStudent(Student student) async {
    final db = await instance.database;

    return await db.update(
      studentsTable,
      student.toMap(),
      where: '${StudentFields.id} = ?',
      whereArgs: [student.id],
    );
  }

  //! D --> CRUD = Delete
  Future<int> deleteStudent(int id) async {
    final db = await instance.database;

    return await db.delete(
      studentsTable,
      where: '${StudentFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

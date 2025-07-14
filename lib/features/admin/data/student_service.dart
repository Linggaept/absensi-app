import 'dart:math';
import 'package:absensi/common/models/student_model.dart';

/// A mock service for managing students.
class StudentService {
  // Mock database
  static final List<Student> _students = [
    Student(id: '1', nis: '12345', fullName: 'Andi Pratama', email: 'andi.p@siswa.id', className: 'XII IPA 1', phoneNumber: '081111111111', password: 'password123'),
    Student(id: '2', nis: '12346', fullName: 'Citra Lestari', email: 'citra.l@siswa.id', className: 'XII IPA 2', phoneNumber: '082222222222', password: 'password456'),
    Student(id: '3', nis: '12347', fullName: 'Doni Setiawan', email: 'doni.s@siswa.id', className: 'XII IPS 1', phoneNumber: '083333333333', password: 'password789'),
  ];

  Future<List<Student>> getStudents() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_students);
  }

  Future<void> addStudent(Student student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newStudent = Student(
      id: (Random().nextInt(1000) + 10).toString(),
      nis: student.nis,
      fullName: student.fullName,
      email: student.email,
      className: student.className,
      phoneNumber: student.phoneNumber,
      password: student.password,
    );
    _students.add(newStudent);
  }

  Future<void> updateStudent(Student student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _students[index].nis = student.nis;
      _students[index].fullName = student.fullName;
      _students[index].email = student.email;
      _students[index].className = student.className;
      _students[index].phoneNumber = student.phoneNumber;
      if (student.password != null && student.password!.isNotEmpty) {
        _students[index].password = student.password;
      }
    }
  }

  Future<void> deleteStudent(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _students.removeWhere((s) => s.id == id);
  }
}
import 'dart:math';
import 'package:absensi/common/models/teacher_model.dart';

/// A mock service for managing teachers.
/// This class simulates network latency and CRUD operations.
/// In a real application, this would be replaced with actual API calls using `http` or `dio`.
class TeacherService {
  // Mock database
  static final List<Teacher> _teachers = [
    Teacher(
        id: '1',
        nip: '198001012005011001',
        fullName: 'Budi Santoso',
        email: 'budi.s@sekolah.id',
        subject: 'Matematika',
        phoneNumber: '081234567890',
        password: 'password123'),
    Teacher(
        id: '2',
        nip: '198202022006022002',
        fullName: 'Siti Aminah',
        email: 'siti.a@sekolah.id',
        subject: 'Bahasa Indonesia',
        phoneNumber: '081234567891',
        password: 'password456'),
    Teacher(
        id: '3',
        nip: '198503032008031003',
        fullName: 'Agus Wijaya',
        email: 'agus.w@sekolah.id',
        subject: 'Fisika',
        phoneNumber: '081234567892',
        password: 'password789'),
  ];

  Future<List<Teacher>> getTeachers() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_teachers);
  }

  Future<void> addTeacher(Teacher teacher) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newTeacher = Teacher(
      id: (Random().nextInt(1000) + 10).toString(), // simple random id
      fullName: teacher.fullName,
      nip: teacher.nip,
      email: teacher.email,
      subject: teacher.subject,
      phoneNumber: teacher.phoneNumber,
      password: teacher.password,
    );
    _teachers.add(newTeacher);
  }

  Future<void> updateTeacher(Teacher teacher) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _teachers.indexWhere((t) => t.id == teacher.id);
    if (index != -1) {
      _teachers[index].fullName = teacher.fullName;
      _teachers[index].nip = teacher.nip;
      _teachers[index].email = teacher.email;
      _teachers[index].subject = teacher.subject;
      _teachers[index].phoneNumber = teacher.phoneNumber;
      if (teacher.password != null && teacher.password!.isNotEmpty) {
        _teachers[index].password = teacher.password;
      }
    }
  }

  Future<void> deleteTeacher(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _teachers.removeWhere((t) => t.id == id);
  }
}
import 'dart:math';
import 'package:absensi/common/models/class_model.dart';

class ClassService {
  static final List<ClassModel> _classes = [
    ClassModel(
      id: '1',
      classId: 'K-001',
      className: 'XII IPA 1 - MTK',
      teacherName: 'Budi Santoso',
      subjectName: 'Matematika',
      startTime: '07:00',
      endTime: '08:30',
      room: 'R-101',
      studentCount: 30,
    ),
    ClassModel(
      id: '2',
      classId: 'K-002',
      className: 'XII IPA 2 - FIS',
      teacherName: 'Agus Wijaya',
      subjectName: 'Fisika',
      startTime: '09:00',
      endTime: '10:30',
      room: 'R-102',
      studentCount: 32,
    ),
  ];

  Future<List<ClassModel>> getClasses() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_classes);
  }

  Future<void> addClass(ClassModel classModel) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newClass = ClassModel(
      id: (Random().nextInt(1000) + 10).toString(),
      classId: classModel.classId,
      className: classModel.className,
      teacherName: classModel.teacherName,
      subjectName: classModel.subjectName,
      startTime: classModel.startTime,
      endTime: classModel.endTime,
      room: classModel.room,
      studentCount: classModel.studentCount,
    );
    _classes.add(newClass);
  }

  Future<void> updateClass(ClassModel classModel) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _classes.indexWhere((c) => c.id == classModel.id);
    if (index != -1) {
      _classes[index] = classModel;
    }
  }

  Future<void> deleteClass(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _classes.removeWhere((c) => c.id == id);
  }
}
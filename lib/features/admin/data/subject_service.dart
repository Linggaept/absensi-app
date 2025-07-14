import 'dart:math';
import 'package:absensi/common/models/subject_model.dart';

class SubjectService {
  static final List<Subject> _subjects = [
    Subject(
      id: '1',
      subjectId: 'MTK-01',
      subjectName: 'Matematika Dasar',
      subjectCode: 'MTK-DASAR',
      major: 'Umum',
      credits: 3,
      description: 'Mata kuliah dasar matematika untuk semua jurusan.',
    ),
    Subject(
      id: '2',
      subjectId: 'FIS-01',
      subjectName: 'Fisika Mekanika',
      subjectCode: 'FIS-MEKA',
      major: 'IPA',
      credits: 4,
      description: 'Membahas hukum-hukum gerak dan energi.',
    ),
    Subject(
      id: '3',
      subjectId: 'BIO-01',
      subjectName: 'Biologi Sel',
      subjectCode: 'BIO-SEL',
      major: 'IPA',
      credits: 3,
      description: 'Mempelajari struktur dan fungsi sel.',
    ),
  ];

  Future<List<Subject>> getSubjects() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_subjects);
  }

  Future<void> addSubject(Subject subject) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newSubject = Subject(id: (Random().nextInt(1000) + 10).toString(), subjectId: subject.subjectId, subjectName: subject.subjectName, subjectCode: subject.subjectCode, major: subject.major, credits: subject.credits, description: subject.description);
    _subjects.add(newSubject);
  }

  Future<void> updateSubject(Subject subject) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _subjects.indexWhere((s) => s.id == subject.id);
    if (index != -1) {
      _subjects[index] = subject;
    }
  }

  Future<void> deleteSubject(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _subjects.removeWhere((s) => s.id == id);
  }
}
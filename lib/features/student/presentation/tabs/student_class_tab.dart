import 'package:absensi/common/models/class_model.dart';
import 'package:absensi/features/student/presentation/pages/student_presence_page.dart';
import 'package:flutter/material.dart';

class StudentClassTab extends StatelessWidget {
  StudentClassTab({super.key});

  // Data dummy untuk daftar kelas
  final List<ClassModel> dummyClasses = [
    ClassModel(
      id: '1',
      classId: 'C10A',
      className: 'Kelas 10A',
      teacherName: 'Budi Santoso',
      subjectName: 'Matematika',
      startTime: '07:00',
      endTime: '08:30',
      room: 'R-101',
      studentCount: 30,
    ),
    ClassModel(
      id: '2',
      classId: 'C11B',
      className: 'Kelas 11B',
      teacherName: 'Siti Aminah',
      subjectName: 'Fisika',
      startTime: '09:00',
      endTime: '10:30',
      room: 'R-202',
      studentCount: 32,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Jadwal Kelas Hari Ini',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dummyClasses.length,
          itemBuilder: (context, index) {
            final aClass = dummyClasses[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                title: Text('${aClass.className} - ${aClass.subjectName}'),
                subtitle: Text(
                    '${aClass.teacherName} | ${aClass.startTime} - ${aClass.endTime}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => StudentPresencePage(classModel: aClass)));
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/features/student/models/student_recap_model.dart';
import 'package:flutter/material.dart';

class StudentRecapTab extends StatelessWidget {
  const StudentRecapTab({super.key});

  // Data dummy untuk rekapitulasi siswa
  final List<StudentRecapModel> dummyRecaps = const [
    StudentRecapModel(
      id: 'sr1',
      className: 'Kelas 10A',
      subjectName: 'Matematika',
      teacherName: 'Budi Santoso',
      date: '13-07-2025',
      startTime: '07:00',
      endTime: '08:30',
      presenceCount: 1,
    ),
    StudentRecapModel(
      id: 'sr2',
      className: 'Kelas 11B',
      subjectName: 'Fisika',
      teacherName: 'Siti Aminah',
      date: '13-07-2025',
      startTime: '09:00',
      endTime: '10:30',
      presenceCount: 1,
    ),
    StudentRecapModel(
      id: 'sr3',
      className: 'Kelas 10A',
      subjectName: 'Matematika',
      teacherName: 'Budi Santoso',
      date: '12-07-2025',
      startTime: '07:00',
      endTime: '08:30',
      presenceCount: 0,
    ),
    StudentRecapModel(
      id: 'sr4',
      className: 'Kelas 11B',
      subjectName: 'Fisika',
      teacherName: 'Siti Aminah',
      date: '11-07-2025',
      startTime: '09:00',
      endTime: '10:30',
      presenceCount: 0,
    ),
  ];

  Color _getStatusColor(int presenceCount) {
    if (presenceCount > 0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
      
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: dummyRecaps.length,
      itemBuilder: (context, index) {
        final recap = dummyRecaps[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text('${recap.className} - ${recap.subjectName}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4.0),
                Text('Guru: ${recap.teacherName}'),
                Text('Waktu: ${recap.date}, ${recap.startTime} - ${recap.endTime}'),
              ],
            ),
            trailing: Chip(label: Text(recap.presenceCount.toString(), style: const TextStyle(color: AppColors.white)), backgroundColor: _getStatusColor(recap.presenceCount)),
          ),
        );
      },
    );
  }
}
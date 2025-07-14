import 'package:absensi/features/teacher/models/recap_model.dart';
import 'package:flutter/material.dart';

class RecapTab extends StatelessWidget {
  const RecapTab({super.key});

  // Data dummy untuk rekapitulasi
  // Data diubah menjadi rekapitulasi per siswa
  final List<RecapModel> dummyRecaps = const [
    RecapModel(
      id: 'recap-s1-mat',
      studentName: 'Ahmad',
      className: 'Kelas 10A',
      subjectName: 'Matematika',
      presentCount: 18,
      totalMeetings: 20,
    ),
    RecapModel(
      id: 'recap-s2-mat',
      studentName: 'Budi',
      className: 'Kelas 10A',
      subjectName: 'Matematika',
      presentCount: 20,
      totalMeetings: 20,
    ),
    RecapModel(
      id: 'recap-s3-fis',
      studentName: 'Citra',
      className: 'Kelas 11B',
      subjectName: 'Fisika',
      presentCount: 19,
      totalMeetings: 20,
    ),
    RecapModel(
      id: 'recap-s4-kim',
      studentName: 'Dewi',
      className: 'Kelas 12C',
      subjectName: 'Kimia',
      presentCount: 15,
      totalMeetings: 18,
    ),
  ];

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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(recap.studentName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${recap.className} - ${recap.subjectName}'),
            trailing: Text(
                '${recap.presentCount}/${recap.totalMeetings}\nKehadiran',
                textAlign: TextAlign.center),
          ),
        );
      },
    );
  }
}
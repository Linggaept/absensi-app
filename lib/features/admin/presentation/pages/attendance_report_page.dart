import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/features/admin/models/attendance_report_model.dart';
import 'package:flutter/material.dart';

class AttendanceReportPage extends StatelessWidget {
  const AttendanceReportPage({super.key});

  // Data dummy untuk laporan
  final List<AttendanceReportModel> dummyReports = const [
    AttendanceReportModel(
      studentNis: '22.12.2515',
      studentName: 'Ahmad',
      teacherName: 'Budi Santoso',
      className: 'Kelas 10A',
      subjectName: 'Matematika',
      presenceCount: 18,
      totalMeetings: 20,
    ),
    AttendanceReportModel(
      studentNis: '22.12.2516',
      studentName: 'Budi',
      teacherName: 'Budi Santoso',
      className: 'Kelas 10A',
      subjectName: 'Matematika',
      presenceCount: 20,
      totalMeetings: 20,
    ),
    AttendanceReportModel(
      studentNis: '22.12.2517',
      studentName: 'Citra',
      teacherName: 'Siti Aminah',
      className: 'Kelas 11B',
      subjectName: 'Fisika',
      presenceCount: 19,
      totalMeetings: 20,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Laporan Absensi',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyReports.length,
        itemBuilder: (context, index) {
          final report = dummyReports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${report.studentName} (${report.studentNis})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 4),
                  _buildReportRow(
                    'Kelas',
                    '${report.className} - ${report.subjectName}',
                  ),
                  _buildReportRow('Guru Pengajar', report.teacherName),
                  const SizedBox(height: 8.0),
                  _buildHighlightedRow(
                    'Jumlah Kehadiran',
                    '${report.presenceCount} dari ${report.totalMeetings} pertemuan',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildHighlightedRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ),
          Text(
            ': ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

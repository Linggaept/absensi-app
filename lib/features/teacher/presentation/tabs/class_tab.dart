import 'package:flutter/material.dart';
import 'package:absensi/common/models/class_model.dart';
import 'package:absensi/features/teacher/presentation/pages/presence_page.dart';
import 'package:absensi/features/teacher/services/class_teacher_service.dart';
import 'package:absensi/features/teacher/models/class_teacher_model.dart';
import 'package:absensi/features/auth/data/simple_token_service.dart';

class ClassTab extends StatefulWidget {
  const ClassTab({super.key});

  @override
  State<ClassTab> createState() => _ClassTabState();
}

class _ClassTabState extends State<ClassTab> {
  List<ClassModel> classes = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Ganti dengan guru_id yang sebenarnya
      // Bisa didapat dari token atau user session
      final int guruId = SimpleTokenService.getUserId() ?? 0;

      final List<ClassTeacherModel> teacherClasses =
          await ClassTeacherService.getClassesByTeacherId(guruId);

      // Convert ClassTeacherModel ke ClassModel
      final List<ClassModel> convertedClasses = teacherClasses
          .map(
            (teacherClass) => ClassModel(
              id: teacherClass.id,
              nama_kelas: teacherClass.namaKelas,
              guru_id: teacherClass.guruId,
              waktu_mulai: teacherClass.startTime,
              waktu_selesai: teacherClass.endTime,
              ruangan: teacherClass.ruangan,
              jumlah_siswa: teacherClass.jumlahSiswa,
            ),
          )
          .toList();

      setState(() {
        classes = convertedClasses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _refreshClasses() async {
    await _loadClasses();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshClasses,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Pilih Kelas untuk Presensi',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16.0),

          // Loading indicator
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),

          // Error message
          if (errorMessage.isNotEmpty && !isLoading)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Terjadi Kesalahan',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _refreshClasses,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ),

          // Empty state
          if (classes.isEmpty && !isLoading && errorMessage.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(Icons.school_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Belum ada kelas yang tersedia',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

          // Classes list
          if (classes.isNotEmpty && !isLoading)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final aClass = classes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    title: Text('${aClass.nama_kelas}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jadwal: ${aClass.waktu_mulai} - ${aClass.waktu_selesai}',
                        ),
                        Text('Ruangan: ${aClass.ruangan}'),
                        Text('Jumlah Siswa: ${aClass.jumlah_siswa}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PresencePage(classModel: aClass),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

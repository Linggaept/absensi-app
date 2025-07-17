// presentation/pages/student_class_tab.dart
import 'package:absensi/common/models/class_model.dart';
import 'package:absensi/features/student/presentation/pages/student_presence_page.dart';
import 'package:flutter/material.dart';
import 'package:absensi/features/student/services/student_class_service.dart';
import 'package:absensi/features/student/models/student_class_model.dart';

class StudentClassTab extends StatefulWidget {
  const StudentClassTab({super.key});

  @override
  State<StudentClassTab> createState() => _StudentClassTabState();
}

class _StudentClassTabState extends State<StudentClassTab> {
  List<StudentClassModel> classes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedClasses = await StudentClassService.getStudentClasses();
      
      setState(() {
        classes = fetchedClasses;
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
            'Jadwal Kelas Hari Ini',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16.0),
          
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (errorMessage != null)
            _buildErrorWidget()
          else if (classes.isEmpty)
            _buildEmptyWidget()
          else
            _buildClassList(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Terjadi Kesalahan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'Tidak dapat memuat data kelas',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadClasses,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak Ada Kelas Hari Ini',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Jadwal kelas kosong untuk hari ini',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildClassList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final studentClass = classes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 2,
          child: ListTile(
            title: Text(
              studentClass.namaKelas,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Guru: ${studentClass.namaGuru}'),
                Text('Waktu: ${studentClass.waktuMulai.substring(0, 5)} - ${studentClass.waktuSelesai.substring(0, 5)}'),
                Text('Ruangan: ${studentClass.ruangan}'),
                Text('Jumlah Siswa: ${studentClass.jumlahSiswa}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Konversi StudentClassModel ke ClassModel untuk StudentPresencePage
              final classModel = ClassModel(
                id: studentClass.id,
                nama_kelas: studentClass.namaKelas,
                guru_id: studentClass.guruId,
                waktu_mulai: studentClass.waktuMulai,
                waktu_selesai: studentClass.waktuSelesai,
                ruangan: studentClass.ruangan,
                jumlah_siswa: studentClass.jumlahSiswa,
              );
              
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StudentPresencePage(classModel: classModel),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
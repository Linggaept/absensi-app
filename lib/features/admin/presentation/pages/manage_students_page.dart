import 'package:flutter/material.dart';
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/common/models/student_model.dart';
import 'package:absensi/features/admin/data/student_service.dart';
import 'package:absensi/features/admin/presentation/pages/add_edit_student_page.dart';

class ManageStudentsPage extends StatefulWidget {
  const ManageStudentsPage({super.key});

  @override
  State<ManageStudentsPage> createState() => _ManageStudentsPageState();
}

class _ManageStudentsPageState extends State<ManageStudentsPage> {
  late Future<List<Student>> _studentsFuture;
  final StudentService _studentService = StudentService();

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    setState(() {
      _studentsFuture = _studentService.getStudents();
    });
  }

  void _navigateToAddEditPage({Student? student}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditStudentPage(student: student),
      ),
    );

    if (result is Student) {
      if (!mounted) return;

      try {
        if (student == null) {
          await _studentService.addStudent(result);
          if (!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Siswa berhasil ditambahkan')));
        } else {
          await _studentService.updateStudent(result);
          if (!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Data siswa berhasil diperbarui')));
        }
        _loadStudents();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Terjadi kesalahan: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ));
      }
    }
  }

  void _deleteStudent(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Siswa'),
        content: const Text('Apakah Anda yakin ingin menghapus data siswa ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: const Text('Batal')
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text('Hapus', style: TextStyle(color: AppColors.error))
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;
      
      try {
        await _studentService.deleteStudent(id.toString());
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Siswa berhasil dihapus')));
        _loadStudents();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Terjadi kesalahan: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Kelola Siswa',
            style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<Student>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadStudents,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Tidak ada data siswa.',
                    style: TextStyle(color: AppColors.textSecondary)));
          }

          final students = snapshot.data!;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person_outline, color: AppColors.primary),
                  ),
                  title: Text(student.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('NIS: ${student.nis} | Kelas ID: ${student.kelasId}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.textSecondary),
                        onPressed: () =>
                            _navigateToAddEditPage(student: student),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.error),
                        onPressed: () => _deleteStudent(student.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditPage(),
        tooltip: 'Tambah Siswa',
        child: const Icon(Icons.add),
      ),
    );
  }
}
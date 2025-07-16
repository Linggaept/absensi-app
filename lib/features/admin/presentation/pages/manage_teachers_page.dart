import 'package:flutter/material.dart';
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/common/models/teacher_model.dart';
import 'package:absensi/features/admin/data/teacher_service.dart';
import 'package:absensi/features/admin/presentation/pages/add_edit_teacher_page.dart';

class ManageTeachersPage extends StatefulWidget {
  const ManageTeachersPage({super.key});

  @override
  State<ManageTeachersPage> createState() => _ManageTeachersPageState();
}

class _ManageTeachersPageState extends State<ManageTeachersPage> {
  late Future<List<Teacher>> _teachersFuture;
  final TeacherService _teacherService = TeacherService();

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  void _loadTeachers() {
    setState(() {
      _teachersFuture = _teacherService.getTeachers();
      if (!mounted) return;
    });
  }

  void _navigateToAddEditPage({Teacher? teacher}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditTeacherPage(teacher: teacher),
      ),
    );

    if (result is Teacher) {
      // Check if the widget is still in the tree
      if (!mounted) return;

      if (teacher == null) {
        // Add new teacher
        await _teacherService.addTeacher(result);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              const SnackBar(content: Text('Guru berhasil ditambahkan')));
      } else {
        // Update existing teacher
        await _teacherService.updateTeacher(result);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text('Data guru berhasil diperbarui')));
      }
      _loadTeachers();
    }
  }

  void _deleteTeacher(String id) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Guru'),
        content: const Text('Apakah Anda yakin ingin menghapus data guru ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus',
                  style: TextStyle(color: AppColors.error))),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;
      await _teacherService.deleteTeacher(int.parse(id) as String);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Guru berhasil dihapus')));
      _loadTeachers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Kelola Guru',
            style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        
      ),
      body: FutureBuilder<List<Teacher>>(
        future: _teachersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Tidak ada data guru.',
                    style: TextStyle(color: AppColors.textSecondary)));
          }

          final teachers = snapshot.data!;
          return ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, color: AppColors.primary),
                  ),
                  title: Text(teacher.nama_lengkap,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(teacher.nama_matkul),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.textSecondary),
                        onPressed: () =>
                            _navigateToAddEditPage(teacher: teacher),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.error),
                        onPressed: () => _deleteTeacher(teacher.id.toString()),
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
        tooltip: 'Tambah Guru',
        child: const Icon(Icons.add),
      ),
    );
  }
}
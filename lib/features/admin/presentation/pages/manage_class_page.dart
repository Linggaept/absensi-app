import 'package:flutter/material.dart';
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/common/models/class_model.dart';
import 'package:absensi/features/admin/data/class_service.dart';
import 'package:absensi/features/admin/presentation/pages/add_edit_class_page.dart';

class ManageClassPage extends StatefulWidget {
  const ManageClassPage({super.key});

  @override
  State<ManageClassPage> createState() => _ManageClassPageState();
}

class _ManageClassPageState extends State<ManageClassPage> {
  late Future<List<ClassModel>> _classesFuture;
  final ClassService _classService = ClassService();

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() {
    setState(() {
      _classesFuture = _classService.getClasses();
    });
  }

  void _navigateToAddEditPage({ClassModel? classModel}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditClassPage(classModel: classModel),
      ),
    );

    if (result is ClassModel) {
      if (!mounted) return;

      try {
        if (classModel == null) {
          // Tambah kelas baru
          await _classService.addClass(result);
          if (mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text('Kelas berhasil ditambahkan')));
          }
        } else {
          // Update kelas yang sudah ada
          await _classService.updateClass(result);
          if (mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text('Data kelas berhasil diperbarui')));
          }
        }
        _loadClasses();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  }

  void _deleteClass(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kelas'),
        content: const Text('Apakah Anda yakin ingin menghapus data kelas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;
      try {
        await _classService.deleteClass(id);
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Kelas berhasil dihapus')));
        }
        _loadClasses();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Kelola Kelas',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<ClassModel>>(
        future: _classesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadClasses,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data kelas.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final classes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80), // space for FAB
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classData = classes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            classData.className,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'ID: ${classData.classId}',
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      _buildInfoRow(Icons.person_outline, 'Guru ID: ${classData.guru_id}'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.schedule_outlined,
                          '${classData.startTime} - ${classData.endTime}'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.meeting_room_outlined,
                          'Ruang: ${classData.room}'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.groups_outlined,
                          '${classData.studentCount} Siswa'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: AppColors.textSecondary),
                            onPressed: () =>
                                _navigateToAddEditPage(classModel: classData),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: AppColors.error),
                            onPressed: () => _deleteClass(classData.id.toString()),
                          ),
                        ],
                      )
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
        tooltip: 'Tambah Kelas',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: AppColors.textPrimary)),
      ],
    );
  }
}
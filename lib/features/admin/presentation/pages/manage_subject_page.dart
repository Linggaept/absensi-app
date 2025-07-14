import 'package:flutter/material.dart';
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/common/models/subject_model.dart';
import 'package:absensi/features/admin/data/subject_service.dart';
import 'package:absensi/features/admin/presentation/pages/add_edit_subject_page.dart';

class ManageSubjectPage extends StatefulWidget {
  const ManageSubjectPage({super.key});

  @override
  State<ManageSubjectPage> createState() => _ManageSubjectPageState();
}

class _ManageSubjectPageState extends State<ManageSubjectPage> {
  late Future<List<Subject>> _subjectsFuture;
  final SubjectService _subjectService = SubjectService();

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() {
    setState(() {
      _subjectsFuture = _subjectService.getSubjects();
    });
  }

  void _navigateToAddEditPage({Subject? subject}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditSubjectPage(subject: subject),
      ),
    );

    if (result is Subject) {
      if (!mounted) return;

      if (subject == null) {
        await _subjectService.addSubject(result);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Mata kuliah berhasil ditambahkan')),
          );
      } else {
        await _subjectService.updateSubject(result);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Data mata kuliah berhasil diperbarui'),
            ),
          );
      }
      _loadSubjects();
    }
  }

  void _deleteSubject(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Mata Kuliah'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus data mata kuliah ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;
      await _subjectService.deleteSubject(id);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Mata kuliah berhasil dihapus')),
        );
      _loadSubjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Kelola Mata Kuliah',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Subject>>(
        future: _subjectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data mata kuliah.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final subjects = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.book, color: AppColors.primary),
                  ),
                  title: Text(
                    subject.subjectName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${subject.subjectCode} - ${subject.credits} SKS',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () =>
                            _navigateToAddEditPage(subject: subject),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                        ),
                        onPressed: () => _deleteSubject(subject.id),
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(subject.subjectName),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('ID: ${subject.subjectId}'),
                              Text('Kode: ${subject.subjectCode}'),
                              Text('Jurusan: ${subject.major}'),
                              Text('SKS: ${subject.credits}'),
                              const SizedBox(height: 10),
                              Text(
                                subject.description ?? 'Tidak ada deskripsi.',
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Tutup'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditPage(),
        tooltip: 'Tambah Matkul',
        child: const Icon(Icons.add),
      ),
    );
  }
}

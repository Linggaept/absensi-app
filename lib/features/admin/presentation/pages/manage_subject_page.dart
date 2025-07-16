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
  bool _isLoading = false;

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

      setState(() {
        _isLoading = true;
      });

      try {
        if (subject == null) {
          // Add new subject
          await _subjectService.addSubject(result);
          if (mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Mata kuliah berhasil ditambahkan')),
              );
          }
        } else {
          // Update existing subject
          await _subjectService.updateSubject(result);
          if (mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Data mata kuliah berhasil diperbarui'),
                ),
              );
          }
        }
        _loadSubjects();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Terjadi kesalahan: $e'),
                backgroundColor: AppColors.error,
              ),
            );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _deleteSubject(int id) async {
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

      setState(() {
        _isLoading = true;
      });

      try {
        await _subjectService.deleteSubject(id);
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Mata kuliah berhasil dihapus')),
            );
        }
        _loadSubjects();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Terjadi kesalahan: $e'),
                backgroundColor: AppColors.error,
              ),
            );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
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
          'Kelola Mata Kuliah',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Subject>>(
            future: _subjectsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSubjects,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
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
                        subject.namaMatkul,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${subject.kodeMatkul} - ${subject.pertemuan} Pertemuan',
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
                            title: Text(subject.namaMatkul),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('ID: ${subject.id}'),
                                  Text('Kode: ${subject.kodeMatkul}'),
                                  Text('Jurusan: ${subject.jurusan}'),
                                  Text('Pertemuan: ${subject.pertemuan}'),
                                  const SizedBox(height: 10),
                                  Text(
                                    subject.deskripsi ?? 'Tidak ada deskripsi.',
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
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditPage(),
        tooltip: 'Tambah Matkul',
        child: const Icon(Icons.add),
      ),
    );
  }
}
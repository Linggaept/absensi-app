import 'package:flutter/material.dart';
import 'package:absensi/common/models/teacher_model.dart';
import 'package:absensi/common/models/subject_model.dart';
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/features/admin/data/teacher_service.dart';
import 'package:absensi/features/admin/data/subject_service.dart';

class AddEditTeacherPage extends StatefulWidget {
  final Teacher? teacher;

  const AddEditTeacherPage({super.key, this.teacher});

  @override
  State<AddEditTeacherPage> createState() => _AddEditTeacherPageState();
}

class _AddEditTeacherPageState extends State<AddEditTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _nipController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isEditMode = false;
  bool _isLoading = false;
  List<Subject> _subjects = [];
  Subject? _selectedSubject;

  final SubjectService _subjectService = SubjectService();
  final TeacherService _teacherService = TeacherService();

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.teacher != null;
    _nipController = TextEditingController(text: widget.teacher?.nip ?? '');
    _fullNameController = TextEditingController(
      text: widget.teacher?.nama_lengkap ?? '',
    );
    _emailController = TextEditingController(text: widget.teacher?.email ?? '');
    _phoneController = TextEditingController(
      text: widget.teacher?.nomor_handphone ?? '',
    );

    _loadSubjects();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _nipController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final subjects = await _subjectService.getSubjects();
      setState(() {
        _subjects = subjects;

        // Set selected subject if in edit mode
        if (_isEditMode && widget.teacher?.nama_matkul != null) {
          // Safely find the matching subject without causing an error if not found.
          for (final subject in subjects) {
            if (subject.namaMatkul == widget.teacher!.nama_matkul) {
              _selectedSubject = subject;
              break;
            }
          }
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading subjects: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih mata kuliah'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final teacher = Teacher(
        id: widget.teacher?.id ?? 0,
        nama_lengkap: _fullNameController.text,
        nip: _nipController.text,
        email: _emailController.text,
        mata_kuliah_id: _selectedSubject!.id.toString(),
        nomor_handphone: _phoneController.text,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
        nama_matkul: '',
      );

      if (widget.teacher == null) {
        await _teacherService.addTeacher(teacher);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Guru berhasil ditambahkan'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await _teacherService.updateTeacher(teacher);
        if (mounted) {
          print('teacher updated: ${teacher.toJson()}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Guru berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan guru: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.teacher == null ? 'Tambah Guru' : 'Edit Guru',
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nipController,
                      enabled: !_isEditMode,
                      maxLength: 18,
                      decoration: const InputDecoration(
                        labelText: 'NIP (Nomor Induk Pegawai)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIP tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Masukkan email yang valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Dropdown untuk mata kuliah
                    DropdownButtonFormField<Subject>(
                      value: _selectedSubject,
                      decoration: const InputDecoration(
                        labelText: 'Mata Kuliah',
                      ),
                      items: _subjects.map((Subject subject) {
                        return DropdownMenuItem<Subject>(
                          value: subject,
                          child: Text(subject.namaMatkul),
                        );
                      }).toList(),
                      onChanged: (Subject? newValue) {
                        setState(() {
                          _selectedSubject = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Silakan pilih mata kuliah';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Handphone',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor handphone tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (!_isEditMode)
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 16),
                    if (!_isEditMode)
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Konfirmasi Password',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Password tidak sama';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

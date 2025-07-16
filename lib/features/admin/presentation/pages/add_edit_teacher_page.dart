import 'package:flutter/material.dart';
import 'package:absensi/common/models/teacher_model.dart';
import 'package:absensi/common/constants/app_colors.dart';

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
  late TextEditingController _subjectController;
  late TextEditingController _phoneController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.teacher != null;
    _nipController = TextEditingController(text: widget.teacher?.nip ?? '');
    _fullNameController = TextEditingController(text: widget.teacher?.nama_lengkap ?? '');
    _emailController = TextEditingController(text: widget.teacher?.email ?? '');
    _subjectController = TextEditingController(text: widget.teacher?.mata_kuliah_id.toString() ?? '');
    _phoneController = TextEditingController(text: widget.teacher?.nomor_handphone ?? '');

  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _nipController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    if (!_isEditMode) {
      _passwordController.dispose();
    }
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final teacher = Teacher(
      id: widget.teacher?.id ?? 0,
      nama_lengkap: _fullNameController.text,
      nip: _nipController.text,
      email: _emailController.text,
      mata_kuliah_id: int.tryParse(_subjectController.text) ?? 0,
      nomor_handphone: _phoneController.text,
      password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
    );

    Navigator.of(context).pop(teacher);

    if (widget.teacher == null) {
      // await _teacherService.addTeacher(teacher);
      print('Menambahkan guru baru: ${teacher.nama_lengkap}');
    } else {
      // await _teacherService.updateTeacher(teacher);
      print('Memperbarui guru: ${teacher.nama_lengkap}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(widget.teacher == null ? 'Tambah Guru' : 'Edit Guru',
            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
           physics: const NeverScrollableScrollPhysics(),
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _nipController,
                enabled: !_isEditMode,
                maxLength: 18,
                decoration: const InputDecoration(labelText: 'NIP (Nomor Induk Pegawai)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Mata Kuliah'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mata kuliah tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Nomor Handphone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor handphone tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), if (!_isEditMode)
                 TextFormField(
                   controller: _passwordController,
                   decoration: const InputDecoration(labelText: 'Password'),
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
              const SizedBox(height: 16), if (!_isEditMode)
                 TextFormField(
                   controller: _confirmPasswordController,
                   decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
                   obscureText: true,
                   validator: (value) {
                     if (value != _passwordController.text) {
                       return 'Password tidak sama';
                     }
                     return null;
                   },
                 ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
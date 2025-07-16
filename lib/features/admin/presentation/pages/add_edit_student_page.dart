import 'package:flutter/material.dart';
import 'package:absensi/common/models/student_model.dart';
import 'package:absensi/common/constants/app_colors.dart';

class AddEditStudentPage extends StatefulWidget {
  final Student? student;

  const AddEditStudentPage({super.key, this.student});

  @override
  State<AddEditStudentPage> createState() => _AddEditStudentPageState();
}

class _AddEditStudentPageState extends State<AddEditStudentPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nisController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _kelasIdController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.student != null;
    _nisController = TextEditingController(text: widget.student?.nis ?? '');
    _fullNameController = TextEditingController(text: widget.student?.fullName ?? '');
    _emailController = TextEditingController(text: widget.student?.email ?? '');
    _kelasIdController = TextEditingController(text: widget.student?.kelasId.toString() ?? '');
    _phoneController = TextEditingController(text: widget.student?.phoneNumber ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nisController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _kelasIdController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final studentData = Student(
        id: widget.student?.id ?? 0,
        nis: _nisController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
        kelasId: int.parse(_kelasIdController.text),
        phoneNumber: _phoneController.text,
        password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
      );
      Navigator.of(context).pop(studentData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.student == null ? 'Tambah Siswa' : 'Edit Siswa',
          style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nisController,
                decoration: const InputDecoration(
                  labelText: 'NIS (Nomor Induk Siswa)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => (value?.isEmpty ?? true) ? 'NIS tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value?.isEmpty ?? true) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value!.contains('@')) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kelasIdController,
                decoration: const InputDecoration(
                  labelText: 'Kelas ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Kelas ID tidak boleh kosong';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Kelas ID harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Handphone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => (value?.isEmpty ?? true) ? 'Nomor handphone tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  hintText: _isEditMode ? 'Kosongkan jika tidak ingin mengubah' : null,
                ),
                obscureText: true,
                validator: (value) => !_isEditMode && (value == null || value.isEmpty) 
                    ? 'Password tidak boleh kosong' 
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
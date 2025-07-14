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
  late TextEditingController _classController;
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
    _classController = TextEditingController(text: widget.student?.className ?? '');
    _phoneController = TextEditingController(text: widget.student?.phoneNumber ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nisController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _classController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final studentData = Student(
        id: widget.student?.id ?? '',
        nis: _nisController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
        className: _classController.text,
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
        title: Text(widget.student == null ? 'Tambah Siswa' : 'Edit Siswa',
            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: _nisController, decoration: const InputDecoration(labelText: 'NIS (Nomor Induk Siswa)'), keyboardType: TextInputType.number, validator: (value) => (value?.isEmpty ?? true) ? 'NIS tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Nama Lengkap'), validator: (value) => (value?.isEmpty ?? true) ? 'Nama tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (value) => (value?.isEmpty ?? true) || !value!.contains('@') ? 'Masukkan email yang valid' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _classController, decoration: const InputDecoration(labelText: 'Kelas'), validator: (value) => (value?.isEmpty ?? true) ? 'Kelas tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Nomor Handphone'), keyboardType: TextInputType.phone, validator: (value) => (value?.isEmpty ?? true) ? 'Nomor handphone tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password', hintText: _isEditMode ? 'Kosongkan jika tidak ingin mengubah' : null),
                obscureText: true,
                validator: (value) => !_isEditMode && (value == null || value.isEmpty) ? 'Password tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _saveForm, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)), child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
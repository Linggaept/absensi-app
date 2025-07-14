import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:absensi/common/models/subject_model.dart';
import 'package:absensi/common/constants/app_colors.dart';

class AddEditSubjectPage extends StatefulWidget {
  final Subject? subject;

  const AddEditSubjectPage({super.key, this.subject});

  @override
  State<AddEditSubjectPage> createState() => _AddEditSubjectPageState();
}

class _AddEditSubjectPageState extends State<AddEditSubjectPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _subjectIdController;
  late TextEditingController _subjectNameController;
  late TextEditingController _subjectCodeController;
  late TextEditingController _majorController;
  late TextEditingController _creditsController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _subjectIdController = TextEditingController(
      text: widget.subject?.subjectId ?? '',
    );
    _subjectNameController = TextEditingController(
      text: widget.subject?.subjectName ?? '',
    );
    _subjectCodeController = TextEditingController(
      text: widget.subject?.subjectCode ?? '',
    );
    _majorController = TextEditingController(text: widget.subject?.major ?? '');
    _creditsController = TextEditingController(
      text: widget.subject?.credits.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.subject?.description ?? '',
    );
  }

  @override
  void dispose() {
    _subjectIdController.dispose();
    _subjectNameController.dispose();
    _subjectCodeController.dispose();
    _majorController.dispose();
    _creditsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final subjectData = Subject(
        id: widget.subject?.id ?? '',
        subjectId: _subjectIdController.text,
        subjectName: _subjectNameController.text,
        subjectCode: _subjectCodeController.text,
        major: _majorController.text,
        credits: int.tryParse(_creditsController.text) ?? 0,
        description: _descriptionController.text,
      );
      Navigator.of(context).pop(subjectData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.subject == null ? 'Tambah Matkul' : 'Edit Matkul',
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
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
                controller: _subjectIdController,
                decoration: const InputDecoration(labelText: 'Mata Kuliah ID'),
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                ),
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectCodeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Mata Kuliah',
                ),
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _majorController,
                decoration: const InputDecoration(labelText: 'Jurusan'),
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditsController,
                decoration: const InputDecoration(labelText: 'Pertemuan'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (Opsional)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
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

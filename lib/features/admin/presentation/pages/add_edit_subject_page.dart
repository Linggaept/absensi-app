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
  late TextEditingController _namaMatkulController;
  late TextEditingController _kodeMatkulController;
  late TextEditingController _jurusanController;
  late TextEditingController _pertemuanController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    _namaMatkulController = TextEditingController(
      text: widget.subject?.namaMatkul ?? '',
    );
    _kodeMatkulController = TextEditingController(
      text: widget.subject?.kodeMatkul ?? '',
    );
    _jurusanController = TextEditingController(
      text: widget.subject?.jurusan ?? '',
    );
    _pertemuanController = TextEditingController(
      text: widget.subject?.pertemuan.toString() ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.subject?.deskripsi ?? '',
    );
  }

  @override
  void dispose() {
    _namaMatkulController.dispose();
    _kodeMatkulController.dispose();
    _jurusanController.dispose();
    _pertemuanController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final subjectData = Subject(
        id: widget.subject?.id ?? 0,
        namaMatkul: _namaMatkulController.text,
        kodeMatkul: _kodeMatkulController.text,
        jurusan: _jurusanController.text,
        pertemuan: int.tryParse(_pertemuanController.text) ?? 0,
        deskripsi: _deskripsiController.text.isEmpty ? null : _deskripsiController.text,
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
                controller: _namaMatkulController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                ),
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kodeMatkulController,
                decoration: const InputDecoration(
                  labelText: 'Kode Mata Kuliah',
                ),
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jurusanController,
                decoration: const InputDecoration(labelText: 'Jurusan'),
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pertemuanController,
                decoration: const InputDecoration(labelText: 'Pertemuan'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
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
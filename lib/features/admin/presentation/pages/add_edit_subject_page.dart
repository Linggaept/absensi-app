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
  late TextEditingController _idController;
  late TextEditingController _namaMatkulController;
  late TextEditingController _kodeMatkulController;
  late TextEditingController _jurusanController;
  late TextEditingController _pertemuanController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(
      text: widget.subject?.id.toString() ?? '',
    );
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
    _idController.dispose();
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
        id: int.tryParse(_idController.text) ?? 0,
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ID Field - show differently for add vs edit mode
              if (widget.subject != null) ...[
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'ID Mata Kuliah',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true, // Make it read-only for edit mode
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ID mata kuliah wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ] else ...[
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'ID Mata Kuliah',
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan ID mata kuliah (contoh: 100)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ID mata kuliah wajib diisi';
                    }
                    if (int.tryParse(value) == null) {
                      return 'ID mata kuliah harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _namaMatkulController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kodeMatkulController,
                decoration: const InputDecoration(
                  labelText: 'Kode Mata Kuliah',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jurusanController,
                decoration: const InputDecoration(
                  labelText: 'Jurusan',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pertemuanController,
                decoration: const InputDecoration(
                  labelText: 'Pertemuan',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v?.isEmpty ?? true) {
                    return 'Wajib diisi';
                  }
                  if (int.tryParse(v!) == null) {
                    return 'Pertemuan harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (Opsional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
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
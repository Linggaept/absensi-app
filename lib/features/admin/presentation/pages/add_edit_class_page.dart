import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:absensi/common/models/class_model.dart';
import 'package:absensi/common/constants/app_colors.dart';

class AddEditClassPage extends StatefulWidget {
  final ClassModel? classModel;

  const AddEditClassPage({super.key, this.classModel});

  @override
  State<AddEditClassPage> createState() => _AddEditClassPageState();
}

class _AddEditClassPageState extends State<AddEditClassPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _classNameController;
  late TextEditingController _teacherIdController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _roomController;
  late TextEditingController _studentCountController;

  @override
  void initState() {
    super.initState();
    _classNameController = TextEditingController(text: widget.classModel?.nama_kelas ?? '');
    _teacherIdController = TextEditingController(text: widget.classModel?.guru_id.toString() ?? '');
    _startTimeController = TextEditingController(text: widget.classModel?.waktu_mulai ?? '');
    _endTimeController = TextEditingController(text: widget.classModel?.waktu_selesai ?? '');
    _roomController = TextEditingController(text: widget.classModel?.ruangan ?? '');
    _studentCountController = TextEditingController(text: widget.classModel?.jumlah_siswa.toString() ?? '');
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _teacherIdController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _roomController.dispose();
    _studentCountController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final classData = ClassModel.fromForm(
        id: widget.classModel?.id,
        nama_kelas: _classNameController.text,
        guru_id: int.parse(_teacherIdController.text),
        waktu_mulai: _startTimeController.text,
        waktu_selesai: _endTimeController.text,
        ruangan: _roomController.text,
        jumlah_siswa: int.parse(_studentCountController.text),
      );
      Navigator.of(context).pop(classData);
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      // Format waktu dalam format HH:mm:ss
      final String formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      controller.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.classModel == null ? 'Tambah Kelas' : 'Edit Kelas',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              TextFormField(
                controller: _classNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kelas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kelas wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _teacherIdController,
                decoration: const InputDecoration(
                  labelText: 'ID Guru',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID guru wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Waktu Mulai',
                        hintText: 'HH:MM:SS',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(context, _startTimeController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Waktu mulai wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _endTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Waktu Selesai',
                        hintText: 'HH:MM:SS',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(context, _endTimeController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Waktu selesai wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(
                  labelText: 'Ruangan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ruangan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _studentCountController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Siswa',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah siswa wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Jumlah siswa harus berupa angka';
                  }
                  return null;
                },
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
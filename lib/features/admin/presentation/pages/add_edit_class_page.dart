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
  late TextEditingController _classIdController;
  late TextEditingController _classNameController;
  late TextEditingController _teacherNameController;
  late TextEditingController _subjectNameController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _roomController;
  late TextEditingController _studentCountController;

  @override
  void initState() {
    super.initState();
    _classIdController = TextEditingController(text: widget.classModel?.classId ?? '');
    _classNameController = TextEditingController(text: widget.classModel?.className ?? '');
    _teacherNameController = TextEditingController(text: widget.classModel?.teacherName ?? '');
    _subjectNameController = TextEditingController(text: widget.classModel?.subjectName ?? '');
    _startTimeController = TextEditingController(text: widget.classModel?.startTime ?? '');
    _endTimeController = TextEditingController(text: widget.classModel?.endTime ?? '');
    _roomController = TextEditingController(text: widget.classModel?.room ?? '');
    _studentCountController = TextEditingController(text: widget.classModel?.studentCount.toString() ?? '');
  }

  @override
  void dispose() {
    _classIdController.dispose();
    _classNameController.dispose();
    _teacherNameController.dispose();
    _subjectNameController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _roomController.dispose();
    _studentCountController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final classData = ClassModel(
        id: widget.classModel?.id ?? '',
        classId: _classIdController.text,
        className: _classNameController.text,
        teacherName: _teacherNameController.text,
        subjectName: _subjectNameController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        room: _roomController.text,
        studentCount: int.tryParse(_studentCountController.text) ?? 0,
      );
      Navigator.of(context).pop(classData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(widget.classModel == null ? 'Tambah Kelas' : 'Edit Kelas',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: _classIdController, decoration: const InputDecoration(labelText: 'Kelas ID'), validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _classNameController, decoration: const InputDecoration(labelText: 'Nama Kelas'), validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _teacherNameController, decoration: const InputDecoration(labelText: 'Guru'), validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _subjectNameController, decoration: const InputDecoration(labelText: 'Mata Kuliah'), validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _startTimeController, decoration: const InputDecoration(labelText: 'Waktu Mulai', hintText: 'HH:MM'), validator: (v) => (v?.isEmpty ?? true) ? 'Wajib' : null)),
                  const SizedBox(width: 16),
                  Expanded(child: TextFormField(controller: _endTimeController, decoration: const InputDecoration(labelText: 'Waktu Selesai', hintText: 'HH:MM'), validator: (v) => (v?.isEmpty ?? true) ? 'Wajib' : null)),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _roomController, decoration: const InputDecoration(labelText: 'Ruangan'), validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _studentCountController, decoration: const InputDecoration(labelText: 'Jumlah Siswa'), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: _saveForm, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)), child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
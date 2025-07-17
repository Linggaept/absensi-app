import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:absensi/common/models/class_model.dart';
import 'package:absensi/common/models/teacher_model.dart';
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/features/admin/data/teacher_service.dart';

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
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _roomController;
  late TextEditingController _studentCountController;

  final TeacherService _teacherService = TeacherService();
  List<Teacher> _teachers = [];
  Teacher? _selectedTeacher;
  bool _isLoadingTeachers = true;
  String? _teacherErrorMessage;

  @override
  void initState() {
    super.initState();
    _classIdController = TextEditingController(
      text: widget.classModel?.id.toString() ?? ''
    );
    _classNameController = TextEditingController(
      text: widget.classModel?.nama_kelas ?? ''
    );
    _startTimeController = TextEditingController(
      text: widget.classModel?.waktu_mulai ?? ''
    );
    _endTimeController = TextEditingController(
      text: widget.classModel?.waktu_selesai ?? ''
    );
    _roomController = TextEditingController(
      text: widget.classModel?.ruangan ?? ''
    );
    _studentCountController = TextEditingController(
      text: widget.classModel?.jumlah_siswa.toString() ?? ''
    );
    
    _loadTeachers();
  }

  @override
  void dispose() {
    _classIdController.dispose();
    _classNameController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _roomController.dispose();
    _studentCountController.dispose();
    super.dispose();
  }

  Future<void> _loadTeachers() async {
    try {
      setState(() {
        _isLoadingTeachers = true;
        _teacherErrorMessage = null;
      });

      final teachers = await _teacherService.getTeachers();
      setState(() {
        _teachers = teachers;
        _isLoadingTeachers = false;
        
        // Jika dalam mode edit, cari dan set guru yang sesuai
        if (widget.classModel != null) {
          _selectedTeacher = _teachers.firstWhere(
            (teacher) => teacher.id == widget.classModel!.guru_id,
            orElse: () => _teachers.isNotEmpty ? _teachers.first : null as Teacher,
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingTeachers = false;
        _teacherErrorMessage = e.toString();
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTeacher == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih guru terlebih dahulu')),
        );
        return;
      }

      final classData = ClassModel.fromForm(
        id: widget.classModel?.id ?? int.tryParse(_classIdController.text),
        nama_kelas: _classNameController.text,
        guru_id: _selectedTeacher!.id,
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

  Widget _buildTeacherDropdown() {
    if (_isLoadingTeachers) {
      return DropdownButtonFormField<Teacher>(
        decoration: const InputDecoration(
          labelText: 'Guru',
          border: OutlineInputBorder(),
        ),
        items: [],
        onChanged: null,
        hint: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Memuat data guru...'),
          ],
        ),
      );
    }

    if (_teacherErrorMessage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<Teacher>(
            decoration: const InputDecoration(
              labelText: 'Guru',
              border: OutlineInputBorder(),
            ),
            items: const [],
            onChanged: null,
            hint: const Text('Gagal memuat data guru'),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _teacherErrorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: _loadTeachers,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ],
      );
    }

    if (_teachers.isEmpty) {
      return DropdownButtonFormField<Teacher>(
        decoration: const InputDecoration(
          labelText: 'Guru',
          border: OutlineInputBorder(),
        ),
        items: const [],
        onChanged: null,
        hint: const Text('Tidak ada data guru'),
        validator: (value) => 'Tidak ada data guru tersedia',
      );
    }

    return DropdownButtonFormField<Teacher>(
      decoration: const InputDecoration(
        labelText: 'Guru',
        border: OutlineInputBorder(),
      ),
      value: _selectedTeacher,
      items: _teachers.map((Teacher teacher) {
        return DropdownMenuItem<Teacher>(
          value: teacher,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teacher.nama_lengkap,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (Teacher? newValue) {
        setState(() {
          _selectedTeacher = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Guru wajib dipilih';
        }
        return null;
      },
      isExpanded: true,
    );
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
              // Show ID field only for edit mode, or make it optional for add mode
              if (widget.classModel != null) ...[
                TextFormField(
                  controller: _classIdController,
                  decoration: const InputDecoration(
                    labelText: 'ID Kelas',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true, // Make it read-only for edit mode
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ID kelas wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ] else ...[
                TextFormField(
                  controller: _classIdController,
                  decoration: const InputDecoration(
                    labelText: 'ID Kelas',
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan ID kelas (contoh: 10000)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ID kelas wajib diisi';
                    }
                    if (int.tryParse(value) == null) {
                      return 'ID kelas harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
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
              _buildTeacherDropdown(),
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
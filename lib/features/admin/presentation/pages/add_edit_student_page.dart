import 'package:flutter/material.dart';
import 'package:absensi/common/models/student_model.dart';
import 'package:absensi/common/models/class_model.dart';
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/features/admin/data/class_service.dart';
import 'package:absensi/features/admin/data/subject_service.dart';

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
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  
  bool _isEditMode = false;
  bool _isLoading = false;
  
  List<ClassModel> _classes = [];
  // List<Subject> _subjects = [];
  ClassModel? _selectedClass;
  
  final ClassService _classService = ClassService();
  final SubjectService _subjectService = SubjectService();

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.student != null;
    _nisController = TextEditingController(text: widget.student?.nis ?? '');
    _fullNameController = TextEditingController(text: widget.student?.fullName ?? '');
    _emailController = TextEditingController(text: widget.student?.email ?? '');
    _phoneController = TextEditingController(text: widget.student?.phoneNumber ?? '');
    _passwordController = TextEditingController();
    
    _loadData();
  }

  @override
  void dispose() {
    _nisController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load classes and subjects concurrently
      final results = await Future.wait([
        _classService.getClasses(),
        _subjectService.getSubjects(),
      ]);

      _classes = results[0] as List<ClassModel>;
      // _subjects = results[1] as List<Subject>;

      // Set selected class if in edit mode
      if (_isEditMode && widget.student != null) {
        _selectedClass = _classes.firstWhere(
          (cls) => cls.id == widget.student!.kelasId,
          orElse: () => _classes.first,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // String _getSubjectName(int subjectId) {
  //   try {
  //     final subject = _subjects.firstWhere((s) => s.id == subjectId);
  //     return subject.namaMatkul;
  //   } catch (e) {
  //     return 'Unknown Subject';
  //   }
  // }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedClass == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a class'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final studentData = Student(
        id: widget.student?.id ?? 0,
        nis: _nisController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
        kelasId: _selectedClass!.id,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    DropdownButtonFormField<ClassModel>(
                      value: _selectedClass,
                      decoration: const InputDecoration(
                        labelText: 'Kelas',
                        border: OutlineInputBorder(),
                      ),
                      items: _classes.map((ClassModel cls) {
                        // final subjectName = _getSubjectName(cls.guru_id);
                        return DropdownMenuItem<ClassModel>(
                          value: cls,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                cls.className,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (ClassModel? newValue) {
                        setState(() {
                          _selectedClass = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Pilih kelas' : null,
                      isExpanded: true,
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
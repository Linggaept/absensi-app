import 'package:absensi/common/models/class_model.dart';
import 'package:absensi/common/models/student_model.dart'; // Note: This file defines the 'Student' class
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:absensi/common/constants/app_colors.dart';

class PresencePage extends StatefulWidget {
  final ClassModel classModel;
  const PresencePage({super.key, required this.classModel});

  @override
  State<PresencePage> createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  // Data dummy untuk daftar murid
  // Menggunakan model 'Student' yang sudah ada untuk konsistensi
  final List<Student> dummyStudents = [
    // Student(
    //   id: 's1',
    //   nis: '1001',
    //   fullName: 'Ahmad',
    //   email: 'ahmad@example.com',
    //   className: '10A',
    //   phoneNumber: '081',
    // ),
    // Student(
    //   id: 's2',
    //   nis: '1002',
    //   fullName: 'Budi',
    //   email: 'budi@example.com',
    //   className: '10A',
    //   phoneNumber: '082',
    // ),
    // Student(
    //   id: 's3',
    //   nis: '1003',
    //   fullName: 'Citra',
    //   email: 'citra@example.com',
    //   className: '10A',
    //   phoneNumber: '083',
    // ),
  ];

  // Map untuk menyimpan status presensi
  // Key diubah menjadi String untuk menyesuaikan dengan Student.id
  final Map<String, String> presenceStatus = {};

  // Variabel untuk kode presensi dan input manual
  String? _presenceCode;
  final TextEditingController _nisController = TextEditingController();
  final FocusNode _nisFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Inisialisasi status presensi
    for (var student in dummyStudents) {
      // presenceStatus[student.id] = 'Alpa'; // Default status diubah menjadi Alpa
    }
  }

  @override
  void dispose() {
    _nisController.dispose();
    _nisFocusNode.dispose();
    super.dispose();
  }

  // Fungsi untuk generate kode acak
  String _generateRandomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  // Fungsi untuk presensi manual berdasarkan NIS
  void _manualPresence() {
    final nis = _nisController.text;
    if (nis.isEmpty) {
      return;
    }

    final studentIndex = dummyStudents.indexWhere((s) => s.nis == nis);

    if (studentIndex != -1) {
      final studentId = dummyStudents[studentIndex].id;
      setState(() {
        // presenceStatus[studentId] = 'Hadir';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${dummyStudents[studentIndex].fullName} berhasil dihadirkan.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Siswa dengan NIS tersebut tidak ditemukan.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    _nisController.clear();
    _nisFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Presensi ${widget.classModel.className}', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _presenceCode = _generateRandomCode(5);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sesi presensi dibuka! Kode: $_presenceCode',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Buka Sesi Presensi'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                if (_presenceCode != null) ...[
                  const SizedBox(height: 24),
                  const Text('Kode Presensi:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  SelectableText(
                    _presenceCode!,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nisController,
                    focusNode: _nisFocusNode,
                    decoration: const InputDecoration(
                      labelText: 'Input NIS Manual',
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (_) => _manualPresence(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _manualPresence,
                  child: const Text('Hadirkan'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: dummyStudents.length,
              itemBuilder: (context, index) {
                final student = dummyStudents[index];
                return ListTile(
                  title: Text(student.fullName),
                  trailing: presenceStatus[student.id] == 'Hadir'
                      ? const Chip(
                          label: Text('Hadir',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.green,
                        )
                      : const Chip(
                          label: Text('Dibatalkan',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red,
                        ),
                  onTap: () {
                    setState(() {
                      // Toggle kehadiran saat item di-tap
                      // presenceStatus[student.id] =
                          presenceStatus[student.id] == 'Hadir'
                              ? 'Alpa'
                              : 'Hadir';
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Simpan Presensi'),
            ),
          ),
        ],
      ),
    );
  }
}

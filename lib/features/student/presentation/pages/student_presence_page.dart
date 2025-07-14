import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/common/models/class_model.dart';
import 'package:flutter/material.dart';

class StudentPresencePage extends StatefulWidget {
  final ClassModel classModel;
  const StudentPresencePage({super.key, required this.classModel});

  @override
  State<StudentPresencePage> createState() => _StudentPresencePageState();
}

class _StudentPresencePageState extends State<StudentPresencePage> {
  final TextEditingController _codeController = TextEditingController();

  void _submitPresence() {
    final code = _codeController.text;
    if (code.isNotEmpty) {
      // TODO: Validate presence code logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil melakukan presensi untuk kode: $code'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode presensi tidak boleh kosong.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Presensi ${widget.classModel.subjectName}', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Masukkan Kode Presensi', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8.0),
            Text('Kode diberikan oleh guru di kelas ${widget.classModel.className}.', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 32.0),
            TextFormField(
              controller: _codeController,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
              decoration: const InputDecoration(labelText: 'Kode Presensi', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _submitPresence,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Lakukan Presensi'),
            ),
          ],
        ),
      ),
    );
  }
}
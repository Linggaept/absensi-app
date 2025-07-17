import 'dart:math';
import 'package:flutter/material.dart';
import 'package:absensi/common/models/class_model.dart';
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/features/teacher/models/presensi_model.dart';
import 'package:absensi/features/teacher/services/presensi_service.dart';

class PresencePage extends StatefulWidget {
  

  final ClassModel classModel;
  const PresencePage({super.key, required this.classModel});

  @override
  State<PresencePage> createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  // State untuk menyimpan daftar siswa
  List<PresensiSiswaModel> students = [];

  // State untuk menyimpan kode presensi saat ini
  String? currentPresenceCode;

  // State untuk mengontrol auto-refresh
  bool autoRefresh = false;

  // State untuk menyimpan summary presensi
  PresensiSummaryModel? summary;

  // Timer untuk auto-refresh
  // Timer? refreshTimer;

  // Inisialisasi controller dan focus node untuk input manual
  final TextEditingController nisController = TextEditingController();
  final FocusNode nisFocusNode = FocusNode();

  // Variabel untuk kode presensi dan input manual
  String? _presenceCode;
  final TextEditingController _nisController = TextEditingController();
  final FocusNode _nisFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mendapatkan daftar siswa saat inisialisasi
    _getStudentList();
  }

  @override
  void dispose() {
    nisController.dispose();
    nisFocusNode.dispose();
    // refreshTimer?.cancel(); // Batalkan timer jika sedang berjalan
    super.dispose();
  }

  // Fungsi untuk mendapatkan daftar siswa dari API
  Future<void> _getStudentList() async {
    try {
      final data = await PresensiService.getDaftarSiswaPresensi(widget.classModel.id);
      setState(() {
        students = data.data;
        summary = data.summary;
      });
    } catch (e) {
      // Tampilkan pesan error jika gagal mengambil data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data siswa: $e')),
      );
    }
  }

  // Fungsi untuk memulai sesi presensi
  Future<void> _startPresenceSession() async {
    try {
      final result = await PresensiService.mulaiPresensi(widget.classModel.id);
      setState(() {
        currentPresenceCode = result.kodePresensi;
        autoRefresh = result.autoRefresh;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );

      // Memulai timer untuk auto-refresh jika diaktifkan
      // if (autoRefresh) {
      //   _startAutoRefresh(result.refreshInterval);
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memulai sesi: $e')),
      );
    }
  }

  // Fungsi untuk presensi manual berdasarkan NIS
  void _manualPresence() {
    if (nisController.text.isEmpty) return;

    PresensiService.inputManualSiswa(
      widget.classModel.id,
      int.parse(nisController.text),
    ).then((value) {
      nisController.clear();
      nisFocusNode.requestFocus();
      _getStudentList();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil Input Manual'),
        ),
      });
    }).catchError((e) {
      nisController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal Input Manual: $e'),
        ),
      );
    });
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
                if (currentPresenceCode == null)
                  ElevatedButton.icon(
                    onPressed: () {
 _startPresenceSession();
 _getStudentList();
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
                  )
                else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kode Presensi:', style: TextStyle(fontSize: 16)),
                      SelectableText(
                        currentPresenceCode!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                if (currentPresenceCode != null)
                  Expanded(
                    child: TextFormField(
                      controller: nisController,
                      focusNode: nisFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Input NIS Manual',
                        border: OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (_) => _manualPresence(),
                    ),
                  )
                else
                  const SizedBox(),
                if (currentPresenceCode != null) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _manualPresence,
                    child: const Text('Hadirkan'),
                  ),
                ]
              ],
            ),
          ),
          // Expanded(
          //   child: // Daftar Siswa
          //   ),
          // ),
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

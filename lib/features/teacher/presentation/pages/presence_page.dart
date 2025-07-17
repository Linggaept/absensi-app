import 'package:absensi/common/models/class_model.dart';
import 'dart:async';
import 'package:flutter/material.dart';
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
  // Variables untuk API
  String? _presenceCode;
  bool isSessionActive = false;
  bool isLoading = false;
  Timer? _refreshTimer;
  Timer? _codeRefreshTimer;
  DaftarSiswaPresensiModel? daftarSiswa;
  
  // Variables untuk tampilan
  final TextEditingController _nisController = TextEditingController();
  final FocusNode _nisFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _checkCurrentSession();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _codeRefreshTimer?.cancel();
    _nisController.dispose();
    _nisFocusNode.dispose();
    super.dispose();
  }

  Future<void> _checkCurrentSession() async {
    try {
      final current = await PresensiService.getCurrentPresensi(widget.classModel.id);
      setState(() {
        _presenceCode = current.kodePresensi;
        isSessionActive = true;
      });
      _startTimers(current.autoRefresh, current.refreshInterval);
    } catch (e) {
      // Tidak ada sesi aktif
    }
  }

  Future<void> _mulaiPresensi() async {
    setState(() {
      isLoading = true;
    });

    try {
      final session = await PresensiService.mulaiPresensi(widget.classModel.id);
      setState(() {
        _presenceCode = session.kodePresensi;
        isSessionActive = true;
      });
      _startTimers(session.autoRefresh, session.refreshInterval);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(session.message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selesaiPresensi() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await PresensiService.selesaiPresensi(widget.classModel.id);
      setState(() {
        _presenceCode = null;
        isSessionActive = false;
        daftarSiswa = null;
      });
      _refreshTimer?.cancel();
      _codeRefreshTimer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk presensi manual berdasarkan NIS
  Future<void> _manualPresence() async {
    final nis = _nisController.text;
    if (nis.isEmpty) {
      return;
    }

    try {
      final nisInt = int.parse(nis);
      final result = await PresensiService.inputManualSiswa(widget.classModel.id, nisInt);
      _nisController.clear();
      _nisFocusNode.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Siswa berhasil ditambahkan: ${result.status}'),
          backgroundColor: Colors.green,
        ),
      );
      _loadDaftarSiswa();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _batalkanPresensi(int nis) async {
    try {
      await PresensiService.batalkanPresensi(widget.classModel.id, nis);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Presensi berhasil dibatalkan.'),
          backgroundColor: Colors.orange,
        ),
      );
      _loadDaftarSiswa(); // Refresh list to show updated status
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showBatalDialog(PresensiSiswaModel siswa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Pembatalan'),
          content:
              Text('Apakah Anda yakin ingin membatalkan presensi untuk ${siswa.namaLengkap}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Ya, Batalkan'),
              onPressed: () {
                Navigator.of(context).pop();
                _batalkanPresensi(int.parse(siswa.nis));
              },
            ),
          ],
        );
      },
    );
  }

  void _startTimers(bool autoRefresh, int interval) {
    if (!autoRefresh) {
      // Jika auto-refresh tidak aktif, cukup muat data sekali.
      _loadDaftarSiswa();
      return;
    }

    // Gunakan interval dari API, default ke 15 detik jika tidak valid.
    final refreshDuration = Duration(seconds: interval > 0 ? interval : 15);

    // Timer untuk auto-refresh daftar siswa
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(refreshDuration, (timer) {
      if (isSessionActive) {
        _loadDaftarSiswa();
      }
    });
    _loadDaftarSiswa(); // Panggil sekali di awal

    // Timer untuk auto-refresh kode presensi
    _codeRefreshTimer?.cancel();
    _codeRefreshTimer = Timer.periodic(refreshDuration, (timer) {
      if (isSessionActive) {
        _refreshPresenceCode();
      }
    });
  }

  /// Memanggil `getCurrentPresensi` dan memicu re-render jika kode berubah.
  Future<void> _refreshPresenceCode() async {
    try {
      final current =
          await PresensiService.getCurrentPresensi(widget.classModel.id);
      // Cek jika widget masih ter-mount dan kode presensi dari server berbeda
      if (mounted && current.kodePresensi != _presenceCode) {
        setState(() {
          _presenceCode = current.kodePresensi;
        });
      }
    } catch (e) {
      if (mounted) _stopSessionUI();
    }
  }

  Future<void> _loadDaftarSiswa() async {
    try {
      final daftar = await PresensiService.getDaftarSiswaPresensi(widget.classModel.id);
      setState(() {
        daftarSiswa = daftar;
      });
    } catch (e) {
      // Handle error silently untuk auto refresh
    }
  }

  // Fungsi untuk menghentikan semua timer dan mereset UI ke kondisi non-aktif
  void _stopSessionUI() {
    _refreshTimer?.cancel();
    _codeRefreshTimer?.cancel();
    if (mounted) {
      setState(() {
        isSessionActive = false;
        _presenceCode = null;
        daftarSiswa = null;
      });
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesi presensi telah berakhir.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Presensi ${widget.classModel.nama_kelas}', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: isLoading ? null : (isSessionActive ? _selesaiPresensi : _mulaiPresensi),
                  icon: Icon(isSessionActive ? Icons.stop : Icons.qr_code_scanner),
                  label: Text(isSessionActive ? 'Selesai Presensi' : 'Buka Sesi Presensi'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: isSessionActive ? Colors.red : null,
                    foregroundColor: isSessionActive ? Colors.white : null,
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
          if (isSessionActive)
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
                      keyboardType: TextInputType.number,
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
            child: daftarSiswa != null 
              ? ListView.builder(
                  itemCount: daftarSiswa!.data.length,
                  itemBuilder: (context, index) {
                    final siswa = daftarSiswa!.data[index];
                    return ListTile(
                      onTap: siswa.status == 'hadir' ? () => _showBatalDialog(siswa) : null,
                      title: Text(siswa.namaLengkap),
                      subtitle: Text('NIS: ${siswa.nis} - ${siswa.waktuPresensi}'),
                      trailing: siswa.status == 'hadir'
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
                    );
                  },
                )
              : const Center(child: Text('Belum ada data presensi')),
          ),
          if (isSessionActive)
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
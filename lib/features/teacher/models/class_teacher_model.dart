class ClassTeacherModel {
  final int id;
  final String namaKelas;
  final int guruId;
  final String namaGuru;
  final DateTime waktuMulai;
  final DateTime waktuSelesai;
  final String ruangan;
  final int jumlahSiswa;

  ClassTeacherModel({
    required this.id,
    required this.namaKelas,
    required this.guruId,
    required this.namaGuru,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.ruangan,
    required this.jumlahSiswa,
  });

  // Factory constructor untuk membuat instance dari JSON
  factory ClassTeacherModel.fromJson(Map<String, dynamic> json) {
    // Helper untuk mengubah string waktu (HH:mm:ss) menjadi objek DateTime untuk hari ini.
    // DateTime.parse() memerlukan format tanggal lengkap, bukan hanya waktu.
    DateTime _parseTime(String? timeString) {
      if (timeString == null || timeString.isEmpty) return DateTime.now(); // Fallback jika data tidak ada
      final now = DateTime.now();
      final parts = timeString.split(':').map((p) => int.tryParse(p) ?? 0).toList();
      return DateTime(now.year, now.month, now.day, parts[0], parts[1], parts.length > 2 ? parts[2] : 0);
    }

    return ClassTeacherModel(
      id: json['id'] ?? 0,
      namaKelas: json['nama_kelas'] ?? '',
      guruId: json['guru_id'] ?? 0,
      namaGuru: json['nama_guru'] ?? '',
      waktuMulai: _parseTime(json['waktu_mulai']),
      waktuSelesai: _parseTime(json['waktu_selesai']),
      ruangan: json['ruangan'] ?? '',
      jumlahSiswa: json['jumlah_siswa'] ?? 0,
    );
  }

  // Method untuk mengubah instance ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kelas': namaKelas,
      'guru_id': guruId,
      'nama_guru': namaGuru,
      'waktu_mulai': waktuMulai.toIso8601String(),
      'waktu_selesai': waktuSelesai.toIso8601String(),
      'ruangan': ruangan,
      'jumlah_siswa': jumlahSiswa,
    };
  }

  // Method untuk mendapatkan waktu dalam format HH:mm
  String get startTime {
    return '${waktuMulai.hour.toString().padLeft(2, '0')}:${waktuMulai.minute.toString().padLeft(2, '0')}';
  }

  String get endTime {
    return '${waktuSelesai.hour.toString().padLeft(2, '0')}:${waktuSelesai.minute.toString().padLeft(2, '0')}';
  }


}

// Class untuk response API
class ClassTeacherResponse {
  final bool success;
  final String message;
  final List<ClassTeacherModel> data;

  ClassTeacherResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClassTeacherResponse.fromJson(Map<String, dynamic> json) {
    return ClassTeacherResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => ClassTeacherModel.fromJson(item))
              .toList()
          : [],
    );
  }
}
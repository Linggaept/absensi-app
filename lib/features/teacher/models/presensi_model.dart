// presensi_models.dart

class PresensiSessionModel {
  final String message;
  final String kodePresensi;
  final String kelasId;
  final int sessionId;
  final bool autoRefresh;
  final int refreshInterval;

  PresensiSessionModel({
    required this.message,
    required this.kodePresensi,
    required this.kelasId,
    required this.sessionId,
    required this.autoRefresh,
    required this.refreshInterval,
  });

  factory PresensiSessionModel.fromJson(Map<String, dynamic> json) {
    return PresensiSessionModel(
      message: json['message'] ?? '',  // Berikan nilai default '' jika null
      kodePresensi: json['kode_presensi'] ?? '',  // Berikan nilai default '' jika null
      kelasId: json['kelas_id'] ?? '',  // Berikan nilai default '' jika null
      // Pastikan sessionId di-parse sebagai int, handle jika null
      sessionId: int.tryParse(json['session_id'].toString()) ?? 0,
      autoRefresh: json['auto_refresh'] ?? false,
      refreshInterval: json['refresh_interval'] ?? 0,
    );
  }
}

class CurrentPresensiModel {
  final String kodePresensi;
  final String namaKelas;
  final String tanggal;
  final String createdAt;
  final String updatedAt;
  final bool autoRefresh;
  final int refreshInterval;

  CurrentPresensiModel({
    required this.kodePresensi,
    required this.namaKelas,
    required this.tanggal,
    required this.createdAt,
    required this.updatedAt,
    required this.autoRefresh,
    required this.refreshInterval,
  });

  factory CurrentPresensiModel.fromJson(Map<String, dynamic> json) {
    return CurrentPresensiModel(
      kodePresensi: json['kode_presensi'],
      namaKelas: json['nama_kelas'],
      tanggal: json['tanggal'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      autoRefresh: json['auto_refresh'],
      refreshInterval: json['refresh_interval'],
    );
  }
}

class InputManualModel {
  final int nis;
  final String status;

  InputManualModel({
    required this.nis,
    required this.status,
  });

  factory InputManualModel.fromJson(Map<String, dynamic> json) {
    return InputManualModel(
      // Dibuat lebih robust untuk handle jika nis dari API berupa string atau int
      nis: int.tryParse(json['nis'].toString()) ?? 0,
      status: json['status'],
    );
  }
}

class PresensiSummaryModel {
  final int total;
  final int hadir;
  final int dibatalkan;

  PresensiSummaryModel({
    required this.total,
    required this.hadir,
    required this.dibatalkan,
  });

  factory PresensiSummaryModel.fromJson(Map<String, dynamic> json) {
    return PresensiSummaryModel(
      total: json['total'],
      hadir: json['hadir'],
      dibatalkan: json['dibatalkan'],
    );
  }
}

class PresensiSiswaModel {
  final String nis;
  final String namaLengkap;
  final String status;
  final String waktuPresensi;
  final String timestamp;

  PresensiSiswaModel({
    required this.nis,
    required this.namaLengkap,
    required this.status,
    required this.waktuPresensi,
    required this.timestamp,
  });

  factory PresensiSiswaModel.fromJson(Map<String, dynamic> json) {
    return PresensiSiswaModel(
      nis: json['nis'],
      namaLengkap: json['nama_lengkap'],
      status: json['status'],
      waktuPresensi: json['waktu_presensi'],
      timestamp: json['timestamp'],
    );
  }
}

class DaftarSiswaPresensiModel {
  final String tanggal;
  final String namaKelas;
  final PresensiSummaryModel summary;
  final List<PresensiSiswaModel> data;

  DaftarSiswaPresensiModel({
    required this.tanggal,
    required this.namaKelas,
    required this.summary,
    required this.data,
  });

  factory DaftarSiswaPresensiModel.fromJson(Map<String, dynamic> json) {
    return DaftarSiswaPresensiModel(
      tanggal: json['tanggal'],
      namaKelas: json['nama_kelas'],
      summary: PresensiSummaryModel.fromJson(json['summary']),
      data: (json['data'] as List)
          .map((item) => PresensiSiswaModel.fromJson(item))
          .toList(),
    );
  }
}

class SelesaiPresensiModel {
  final String message;
  final String kodePresensi;
  final int deletedRows;
  final bool autoRefreshStopped;

  SelesaiPresensiModel({
    required this.message,
    required this.kodePresensi,
    required this.deletedRows,
    required this.autoRefreshStopped,
  });

  factory SelesaiPresensiModel.fromJson(Map<String, dynamic> json) {
    return SelesaiPresensiModel(
      message: json['message'],
      kodePresensi: json['kode_presensi'],
      deletedRows: json['deleted_rows'],
      autoRefreshStopped: json['auto_refresh_stopped'],
    );
  }
}

class BatalkanPresensiModel {
  final int nis;

  BatalkanPresensiModel({
    required this.nis,
  });

  factory BatalkanPresensiModel.fromJson(Map<String, dynamic> json) {
    return BatalkanPresensiModel(
      // Dibuat lebih robust untuk handle jika nis dari API berupa string atau int
      nis: int.tryParse(json['nis'].toString()) ?? 0,
    );
  }
}
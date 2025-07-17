class ClassModel {
  final int id;
  final String nama_kelas;
  final int guru_id;
  final String waktu_mulai;
  final String waktu_selesai;
  final String ruangan;
  final int jumlah_siswa;

  ClassModel({
    required this.id,
    required this.nama_kelas,
    required this.guru_id,
    required this.waktu_mulai,
    required this.waktu_selesai,
    required this.ruangan,
    required this.jumlah_siswa,
  });

  // Getter untuk kompatibilitas dengan UI yang sudah ada
  String get classId => id.toString();
  String get className => nama_kelas;
  String get teacherName => 'Teacher $guru_id'; // Temporary, bisa diganti dengan nama guru sebenarnya
  String get subjectName => 'Subject'; // Temporary, bisa diganti dengan mata pelajaran sebenarnya
  String get startTime => waktu_mulai;
  String get endTime => waktu_selesai;
  String get room => ruangan;
  int get studentCount => jumlah_siswa;

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? 0,
      nama_kelas: json['nama_kelas'] ?? '',
      guru_id: json['guru_id'] ?? 0,
      waktu_mulai: json['waktu_mulai'] ?? '',
      waktu_selesai: json['waktu_selesai'] ?? '',
      ruangan: json['ruangan'] ?? '',
      jumlah_siswa: json['jumlah_siswa'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kelas': nama_kelas,
      'guru_id': guru_id,
      'waktu_mulai': waktu_mulai,
      'waktu_selesai': waktu_selesai,
      'ruangan': ruangan,
      'jumlah_siswa': jumlah_siswa,
    };
  }

  // Constructor untuk membuat instance baru dari form
  ClassModel.fromForm({
    int? id,
    required String nama_kelas,
    required int guru_id,
    required String waktu_mulai,
    required String waktu_selesai,
    required String ruangan,
    required int jumlah_siswa,
  }) : this(
          id: id ?? 0,
          nama_kelas: nama_kelas,
          guru_id: guru_id,
          waktu_mulai: waktu_mulai,
          waktu_selesai: waktu_selesai,
          ruangan: ruangan,
          jumlah_siswa: jumlah_siswa,
        );

  // Method untuk membuat copy dengan perubahan
  ClassModel copyWith({
    int? id,
    String? nama_kelas,
    int? guru_id,
    String? waktu_mulai,
    String? waktu_selesai,
    String? ruangan,
    int? jumlah_siswa,
  }) {
    return ClassModel(
      id: id ?? this.id,
      nama_kelas: nama_kelas ?? this.nama_kelas,
      guru_id: guru_id ?? this.guru_id,
      waktu_mulai: waktu_mulai ?? this.waktu_mulai,
      waktu_selesai: waktu_selesai ?? this.waktu_selesai,
      ruangan: ruangan ?? this.ruangan,
      jumlah_siswa: jumlah_siswa ?? this.jumlah_siswa,
    );
  }
}
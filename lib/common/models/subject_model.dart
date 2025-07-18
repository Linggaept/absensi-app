class Subject {
  final int id;
  String namaMatkul;
  String kodeMatkul;
  String jurusan;
  int pertemuan;
  String? deskripsi;

  Subject({
    required this.id,
    required this.namaMatkul,
    required this.kodeMatkul,
    required this.jurusan,
    required this.pertemuan,
    this.deskripsi,
  });

  // Convert from JSON
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? 0,
      namaMatkul: json['nama_matkul'] ?? '',
      kodeMatkul: json['kode_matkul'] ?? '',
      jurusan: json['jurusan'] ?? '',
      pertemuan: json['pertemuan'] ?? 0,
      deskripsi: json['deskripsi'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id == 0 ? null : id, // Allow id to be null for new subjects
      'nama_matkul': namaMatkul,
      'kode_matkul': kodeMatkul,
      'jurusan': jurusan,
      'pertemuan': pertemuan,
      'deskripsi': deskripsi,
    };
  }

  // Convert to JSON with ID (for updates)
  Map<String, dynamic> toJsonWithId() {
    return {
      'id': id,
      'nama_matkul': namaMatkul,
      'kode_matkul': kodeMatkul,
      'jurusan': jurusan,
      'pertemuan': pertemuan,
      'deskripsi': deskripsi,
    };
  }
}
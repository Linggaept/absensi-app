class Teacher {
  final int id;
  final String nama_lengkap;
  final String nip;
  final String email;
  final int mata_kuliah_id;
  final String nomor_handphone;
  final String? password;

  Teacher({
    required this.id,
    required this.nip,
    required this.nama_lengkap,
    required this.email,
    required this.mata_kuliah_id,
    required this.nomor_handphone,
    this.password, // Dibuat opsional
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      nama_lengkap: json['nama_lengkap'] ?? '', // Provide default value
      nip: json['nip'] ?? '',
      email: json['email'] ?? '',
      mata_kuliah_id: json['mata_kuliah_id'] ?? 0,
      nomor_handphone: json['nomor_handphone'] ?? '',
      password: json['password'], // Password can be null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama_lengkap": nama_lengkap,
      "nip": nip,
      "email": email,
      "mata_kuliah_id": mata_kuliah_id,
      "nomor_handphone": nomor_handphone,
     "password": password,
    };
  }
}
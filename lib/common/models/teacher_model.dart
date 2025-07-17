class Teacher {
  final int id;
  final String nama_lengkap;
  final String nip;
  final String email;
  final String nama_matkul;
  final String mata_kuliah_id; // Assuming this is the ID of the subject
  final String nomor_handphone;
  final String? password;

  Teacher({
    required this.id,
    required this.nip,
    required this.nama_lengkap,
    required this.email,
    required this.nama_matkul,
    required this.nomor_handphone,
    this.mata_kuliah_id = '', // Default to empty string if not provided
    this.password, // Dibuat opsional
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      nama_lengkap: json['nama_lengkap'] ?? '', // Provide default value
      nip: json['nip'] ?? '',
      email: json['email'] ?? '',
      nama_matkul: json['nama_matkul'] ?? '',
      nomor_handphone: json['nomor_handphone'] ?? '',
      password: json['password'], // Password can be null
      mata_kuliah_id: json['mata_kuliah_id'] ?? '', // Assuming this is the ID of the subject
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama_lengkap": nama_lengkap,
      "nip": nip,
      "email": email,
      "nama_matkul": nama_matkul,
      "nomor_handphone": nomor_handphone,
      "password": password,
      "mata_kuliah_id": mata_kuliah_id, // Include subject ID
    };
  }
}

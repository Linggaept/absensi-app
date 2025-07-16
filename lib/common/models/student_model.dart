class Student {
  final int id;
  String nis; // Nomor Induk Siswa
  String fullName;
  String email;
  String phoneNumber;
  int kelasId; // Changed from className to kelasId to match API
  String? password;

  Student({
    required this.id,
    required this.nis,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.kelasId,
    this.password,
  });

  // Factory constructor for creating Student from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      nis: json['nis'],
      fullName: json['nama_lengkap'],
      email: json['email'],
      phoneNumber: json['nomor_handphone'],
      kelasId: json['kelas_id'],
      password: json['password'],
    );
  }

  // Convert Student to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nis': nis,
      'nama_lengkap': fullName,
      'email': email,
      'nomor_handphone': phoneNumber,
      'kelas_id': kelasId,
    };
    
    // Only include password if it's not null and not empty
    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
    }
    
    return data;
  }

  // Convert Student to JSON for updates (includes id)
  Map<String, dynamic> toJsonForUpdate() {
    final Map<String, dynamic> data = toJson();
    data['id'] = id;
    return data;
  }
}
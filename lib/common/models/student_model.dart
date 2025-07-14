class Student {
  final String id;
  String nis; // Nomor Induk Siswa
  String fullName;
  String email;
  String className; // Kelas
  String phoneNumber;
  String? password;

  Student({
    required this.id,
    required this.nis,
    required this.fullName,
    required this.email,
    required this.className,
    required this.phoneNumber,
    this.password,
  });
}
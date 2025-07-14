class Teacher {
  final String id;
  String nip; // Nomor Induk Pegawai
  String fullName; // Nama Lengkap
  String email;
  String subject; // Mata Kuliah yang diampu
  String phoneNumber; // Nomor Handphone
  String? password; // Sebaiknya hanya digunakan saat membuat/update, jangan disimpan di state UI

  Teacher({
    required this.id,
    required this.nip,
    required this.fullName,
    required this.email,
    required this.subject,
    required this.phoneNumber,
    this.password, // Dibuat opsional
  });
}
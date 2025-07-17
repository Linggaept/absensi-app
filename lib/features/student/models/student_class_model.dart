// models/student_class_model.dart
class StudentClassModel {
  final int id;
  final String namaKelas;
  final int guruId;
  final String waktuMulai;
  final String waktuSelesai;
  final String ruangan;
  final int jumlahSiswa;
  final String namaGuru;

  StudentClassModel({
    required this.id,
    required this.namaKelas,
    required this.guruId,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.ruangan,
    required this.jumlahSiswa,
    required this.namaGuru,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      id: json['id'],
      namaKelas: json['nama_kelas'],
      guruId: json['guru_id'],
      waktuMulai: json['waktu_mulai'],
      waktuSelesai: json['waktu_selesai'],
      ruangan: json['ruangan'],
      jumlahSiswa: json['jumlah_siswa'],
      namaGuru: json['nama_guru'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kelas': namaKelas,
      'guru_id': guruId,
      'waktu_mulai': waktuMulai,
      'waktu_selesai': waktuSelesai,
      'ruangan': ruangan,
      'jumlah_siswa': jumlahSiswa,
      'nama_guru': namaGuru,
    };
  }


}
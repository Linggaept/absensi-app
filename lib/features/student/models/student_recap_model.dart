class StudentRecapModel {
  final String id;
  final String className;
  final String subjectName;
  final String teacherName;
  final String date;
  final String startTime;
  final String endTime;
  final int presenceCount;

  const StudentRecapModel({
    required this.id,
    required this.className,
    required this.subjectName,
    required this.teacherName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.presenceCount,
  });

  factory StudentRecapModel.fromJson(Map<String, dynamic> json) {
    // Konversi persentase kehadiran ke presenceCount
    // Jika persentase > 0, maka presenceCount = 1, jika tidak = 0
    return StudentRecapModel(
      id: json['laporan_id'].toString(),
      className: json['nama_kelas'] ?? '',
      subjectName: json['mata_kuliah'] ?? '',
      teacherName: json['guru_pengajar'] ?? '',
      date: _getCurrentDate(), // Menggunakan tanggal saat ini
      startTime: '07:00', // Default waktu mulai
      endTime: '08:30', // Default waktu selesai
      presenceCount: json['jumlah_kehadiran'] ?? '0',
    );
  }

  // Helper method untuk mendapatkan tanggal saat ini
  static String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
  }
}
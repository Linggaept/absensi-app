class AttendanceReportModel {
  final int? laporanId;
  final String studentNis;
  final String studentName;
  final String teacherName;
  final String className;
  final String subjectName;
  final int presenceCount;
  final int totalMeetings;

  const AttendanceReportModel({
    this.laporanId,
    required this.studentNis,
    required this.studentName,
    required this.teacherName,
    required this.className,
    required this.subjectName,
    required this.presenceCount,
    required this.totalMeetings,
  });

  // Factory constructor untuk membuat instance dari JSON
  factory AttendanceReportModel.fromJson(Map<String, dynamic> json) {
    return AttendanceReportModel(
      laporanId: json['laporan_id'],
      studentNis: json['nis'] ?? '',
      studentName: json['nama_siswa'] ?? '',
      teacherName: json['guru_pengajar'] ?? '',
      className: json['nama_kelas'] ?? '',
      subjectName: json['mata_kuliah'] ?? '',
      presenceCount: json['jumlah_kehadiran'] ?? 0,
      totalMeetings: json['total_pertemuan'] ?? 0,
    );
  }

  // Method untuk mengubah instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'laporan_id': laporanId,
      'nis': studentNis,
      'nama_siswa': studentName,
      'guru_pengajar': teacherName,
      'nama_kelas': className,
      'mata_kuliah': subjectName,
      'jumlah_kehadiran': presenceCount,
      'total_pertemuan': totalMeetings,
    };
  }
}
class RecapModel {
  final int laporanId;
  final String studentName;
  final String nis;
  final String className;
  final String subjectName;
  final String teacherName;
  final int presentCount;
  final int totalMeetings;
  
  const RecapModel({
    required this.laporanId,
    required this.studentName,
    required this.nis,
    required this.className,
    required this.subjectName,
    required this.teacherName,
    required this.presentCount,
    required this.totalMeetings,
  });

  factory RecapModel.fromJson(Map<String, dynamic> json) {
    return RecapModel(
      laporanId: json['laporan_id'],
      studentName: json['nama_siswa'],
      nis: json['nis'],
      className: json['nama_kelas'],
      subjectName: json['mata_kuliah'],
      teacherName: json['guru_pengajar'],
      presentCount: json['jumlah_kehadiran'],
      totalMeetings: json['total_pertemuan'],
    );
  }
}
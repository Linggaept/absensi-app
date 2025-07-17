class StudentSubmitPresenceModel {
  final String message;
  final String siswaId;
  final int kelasId;
  final String status;
  final String timestamp;

  StudentSubmitPresenceModel({
    required this.message,
    required this.siswaId,
    required this.kelasId,
    required this.status,
    required this.timestamp,
  });

  factory StudentSubmitPresenceModel.fromJson(Map<String, dynamic> json) {
    return StudentSubmitPresenceModel(
      message: json['message'] ?? '',
      siswaId: json['siswa_id']?.toString() ?? '',
      kelasId: json['kelas_id'] ?? 0,
      status: json['status'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
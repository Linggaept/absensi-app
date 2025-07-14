class AttendanceReportModel {
  final String studentNis;
  final String studentName;
  final String teacherName;
  final String className;
  final String subjectName;
  final int presenceCount;
  final int totalMeetings;

  const AttendanceReportModel({
    required this.studentNis,
    required this.studentName,
    required this.teacherName,
    required this.className,
    required this.subjectName,
    required this.presenceCount,
    required this.totalMeetings,
  });
}
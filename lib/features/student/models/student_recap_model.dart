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
}
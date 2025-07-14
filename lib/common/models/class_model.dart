class ClassModel {
  final String id;
  String classId;
  String className;
  String teacherName;
  String subjectName;
  String startTime;
  String endTime;
  String room;
  int studentCount;

  ClassModel({
    required this.id,
    required this.classId,
    required this.className,
    required this.teacherName,
    required this.subjectName,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.studentCount,
  });
}
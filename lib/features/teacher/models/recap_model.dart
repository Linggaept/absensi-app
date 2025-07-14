class RecapModel {
  final String id;
  final String studentName;
  final String className;
  final String subjectName;
  final int presentCount;
  final int totalMeetings;

  const RecapModel({
    required this.id,
    required this.studentName,
    required this.className,
    required this.subjectName,
    required this.presentCount,
    required this.totalMeetings,
  });
}
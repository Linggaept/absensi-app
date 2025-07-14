class Subject {
  final String id;
  String subjectId;
  String subjectName;
  String subjectCode;
  String major;
  int credits;
  String? description;

  Subject({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
    required this.major,
    required this.credits,
    this.description,
  });
}
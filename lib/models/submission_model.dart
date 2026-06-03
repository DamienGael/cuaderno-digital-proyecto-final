class SubmissionModel {
  final String id;
  final String taskId;
  final String studentId;
  final String studentName;
  final String comment;
  final DateTime submittedAt;
  final String fileUrl;
  final String fileName;
  final bool graded;
  final int grade;
  final String feedback;

  SubmissionModel({
    required this.id,
    required this.taskId,
    required this.studentId,
    required this.studentName,
    required this.comment,
    required this.submittedAt,
    required this.fileUrl,
    required this.fileName,
    required this.graded,
    required this.grade,
    required this.feedback,
  });

  factory SubmissionModel.fromMap(String id, Map<String, dynamic> map) {
    final submittedAtValue = map['submittedAt'];
    DateTime submittedAt;
    if (submittedAtValue is DateTime) {
      submittedAt = submittedAtValue;
    } else if (submittedAtValue is Map && submittedAtValue['_seconds'] != null) {
      submittedAt = DateTime.fromMillisecondsSinceEpoch((submittedAtValue['_seconds'] as int) * 1000);
    } else {
      submittedAt = DateTime.now();
    }
    return SubmissionModel(
      id: id,
      taskId: map['taskId'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      comment: map['comment'] ?? '',
      submittedAt: submittedAt,
      fileUrl: map['fileUrl'] ?? '',
      fileName: map['fileName'] ?? '',
      graded: map['graded'] ?? false,
      grade: map['grade'] ?? 0,
      feedback: map['feedback'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'studentId': studentId,
      'studentName': studentName,
      'comment': comment,
      'submittedAt': submittedAt,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'graded': graded,
      'grade': grade,
      'feedback': feedback,
    };
  }
}

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final int points;
  final String classId;
  final String professorId;
  final String professorName;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.points,
    required this.classId,
    required this.professorId,
    required this.professorName,
  });

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    final dueDateValue = map['dueDate'];
    DateTime dueDate;
    if (dueDateValue is DateTime) {
      dueDate = dueDateValue;
    } else if (dueDateValue is Map && dueDateValue['_seconds'] != null) {
      dueDate = DateTime.fromMillisecondsSinceEpoch((dueDateValue['_seconds'] as int) * 1000);
    } else {
      dueDate = DateTime.now();
    }
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: dueDate,
      points: map['points'] ?? 100,
      classId: map['classId'] ?? '',
      professorId: map['professorId'] ?? '',
      professorName: map['professorName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'points': points,
      'classId': classId,
      'professorId': professorId,
      'professorName': professorName,
    };
  }
}

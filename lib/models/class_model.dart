class ClassModel {
  final String id;
  final String name;
  final String subject;
  final String description;
  final String classCode;
  final String professorId;
  final String professorName;
  final List<String> students;

  ClassModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.description,
    required this.classCode,
    required this.professorId,
    required this.professorName,
    required this.students,
  });

  factory ClassModel.fromMap(String id, Map<String, dynamic> map) {
    return ClassModel(
      id: id,
      name: map['name'] ?? '',
      subject: map['subject'] ?? '',
      description: map['description'] ?? '',
      classCode: map['classCode'] ?? '',
      professorId: map['professorId'] ?? '',
      professorName: map['professorName'] ?? '',
      students: List<String>.from(map['students'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subject': subject,
      'description': description,
      'classCode': classCode,
      'professorId': professorId,
      'professorName': professorName,
      'students': students,
    };
  }
}

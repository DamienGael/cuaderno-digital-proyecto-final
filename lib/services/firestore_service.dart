import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_model.dart';
import '../models/task_model.dart';
import '../models/submission_model.dart';
import '../models/message_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ClassModel>> classesForUser(String userId) {
    return _firestore.collection('classes').where('students', arrayContains: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ClassModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  Stream<List<ClassModel>> classesForProfessor(String professorId) {
    return _firestore.collection('classes').where('professorId', isEqualTo: professorId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ClassModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  Future<void> createClass(ClassModel classModel) async {
    await _firestore.collection('classes').add(classModel.toMap());
  }

  Future<ClassModel?> getClassById(String id) async {
    final doc = await _firestore.collection('classes').doc(id).get();
    if (!doc.exists) return null;
    return ClassModel.fromMap(doc.id, doc.data()!);
  }

  Future<void> joinClass(String code, String studentId) async {
    final query = await _firestore.collection('classes').where('classCode', isEqualTo: code).limit(1).get();
    if (query.docs.isEmpty) throw Exception('Código de clase inválido');
    final classDoc = query.docs.first;
    await classDoc.reference.update({
      'students': FieldValue.arrayUnion([studentId]),
    });
  }

  Stream<List<TaskModel>> tasksForClass(String classId) {
    return _firestore.collection('tasks').where('classId', isEqualTo: classId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  Future<void> createTask(TaskModel task) async {
    await _firestore.collection('tasks').add(task.toMap());
  }

  Future<void> submitTask(SubmissionModel submission) async {
    await _firestore.collection('submissions').add(submission.toMap());
  }

  Stream<List<SubmissionModel>> submissionsForTask(String taskId) {
    return _firestore.collection('submissions').where('taskId', isEqualTo: taskId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => SubmissionModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  Future<void> gradeSubmission(String submissionId, int grade, String feedback) async {
    await _firestore.collection('submissions').doc(submissionId).update({
      'graded': true,
      'grade': grade,
      'feedback': feedback,
    });
  }

  Stream<List<MessageModel>> messagesForClass(String classId) {
    return _firestore.collection('messages').where('classId', isEqualTo: classId).orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MessageModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  Future<void> sendMessage(MessageModel message) async {
    await _firestore.collection('messages').add(message.toMap());
  }
}

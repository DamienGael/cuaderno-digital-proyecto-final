import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadUserPhoto(String userId, File file) async {
    final ref = _storage.ref('users/$userId/profile/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }

  Future<String> uploadTaskFile(String taskId, File file) async {
    final ref = _storage.ref('tasks/$taskId/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  Future<User?> register(String name, String email, String password, String role) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'role': role,
        'totalPoints': 0,
        'level': 1,
        'badges': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> fetchUser(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (!snapshot.exists) return null;
    return UserModel.fromMap(snapshot.id, snapshot.data()!);
  }
}

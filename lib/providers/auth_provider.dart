import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? user;
  User? firebaseUser;
  bool isLoading = true;
  bool isDarkMode = false;
  String? errorMessage;

  Future<void> initialize() async {
    firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      user = await _authService.fetchUser(firebaseUser!.uid);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    errorMessage = null;
    try {
      final result = await _authService.signIn(email, password);
      if (result != null) {
        firebaseUser = result;
        user = await _authService.fetchUser(firebaseUser!.uid);
        notifyListeners();
        return true;
      }
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password, String role) async {
    errorMessage = null;
    try {
      final result = await _authService.register(name, email, password, role);
      if (result != null) {
        firebaseUser = result;
        user = await _authService.fetchUser(firebaseUser!.uid);
        notifyListeners();
        return true;
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'Error de registro';
      } else {
        errorMessage = e.toString();
      }
      return false;
    }
    return false;
  }

  Future<void> logout() async {
    await _authService.signOut();
    firebaseUser = null;
    user = null;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

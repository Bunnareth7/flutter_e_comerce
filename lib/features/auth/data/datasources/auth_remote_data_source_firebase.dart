import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String email, String password, String name);
  Future<void> resetPassword(String email);   // <-- new
}

class AuthRemoteDataSourceFirebase implements AuthRemoteDataSource {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user!;
      final String? token = await user.getIdToken();
      log('login success for ${user.email}');
      return UserModel(
        id: user.uid,
        email: user.email!,
        name: user.displayName ?? '',
        token: token ?? '',
      );
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user!;
      await user.updateDisplayName(name);
      final String? token = await user.getIdToken();
      log('signUp success for $email');
      return UserModel(
        id: user.uid,
        email: user.email!,
        name: name,
        token: token ?? '',
      );
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // ---------- New: Password Reset ----------
  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
  
}
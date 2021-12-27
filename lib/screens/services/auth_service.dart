import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:attendance_tracker/screens/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  UserAttr? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return UserAttr(user.uid, user.email);
  }

  Stream<UserAttr?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserAttr?> signInWithEmailandPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      Dialogcu.errorDialog(context, message: e.message as String);
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}

class Dialogcu {
  static void errorDialog(BuildContext context, {required String message}) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                message,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  static void signoutDialog(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    await authService.signOut();
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}

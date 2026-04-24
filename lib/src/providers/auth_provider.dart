import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthStateProvider extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> login(String email, String password) async {

    try {

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "success";

    } catch (e) {

      return e.toString();

    }

  }

  Future<void> logout() async {

    await _auth.signOut();

  }

}
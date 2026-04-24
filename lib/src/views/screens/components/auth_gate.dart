import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/views/screens/home_screen.dart';

import '../auth_screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si el usuario está logueado, vamos al Menú
        if (snapshot.hasData) {
          return HomeScreen();
        }
        // Si no, al Login
        return LoginScreen();
      },
    );
  }
}

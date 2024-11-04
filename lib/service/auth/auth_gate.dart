import 'package:chat_app/service/auth/login_or_register.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.hasData) {
          return HomePage();
        } else {
          return const LoginOrRegister();
        }
      },
    );
  }
}

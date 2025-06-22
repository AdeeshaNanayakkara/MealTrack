import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatro/Feature/Auth/pages/home.dart';
import 'package:eatro/Feature/Auth/pages/login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // Listen to the authentication state changes from Firebase
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. While waiting for connection, show a loading indicator.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. If the snapshot has data, it means the user is logged in.
          if (snapshot.hasData) {
            // Take the user to the HomePage.
            return const HomePage();
          }
          // 3. If there's no data, the user is not logged in.
          else {
            // Take the user to the LoginPage.
            return const LoginPage();
          }
        },
      ),
    );
  }
}

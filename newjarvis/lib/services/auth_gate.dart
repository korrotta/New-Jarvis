import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newjarvis/pages/home_page.dart';
import 'package:newjarvis/services/auth_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const HomePage();
            } else if (snapshot.hasError) {
              return const Center(child: Text("An error occurred"));
            } else {
              return const Authentication();
            }
          }),
    );
  }
}

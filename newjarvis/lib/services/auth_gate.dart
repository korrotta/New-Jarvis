import 'package:flutter/material.dart';
import 'package:newjarvis/pages/ai_chat/chat_page.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/services/auth_state.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _apiService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data == true) {
              return const ChatPage();
            } else {
              return const Authentication();
            }
          } else {
            return const Center(child: Text("An error occurred"));
          }
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:newjarvis/models/ai_chat_model.dart';
import 'package:newjarvis/models/basic_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL
  static const String _baseUrl = 'https://api.jarvis.cx';

  // Private Constructor
  ApiService._privateConstructor();

  // Instance
  static final ApiService instance = ApiService._privateConstructor();

  // Factory Constructor
  factory ApiService() => instance;

  // Store the token in SharedPreferences
  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Retrieve the token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // API call method
  // Sign in
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/api/v1/auth/sign-in');

    print('Signing in with email: $email');
    print('Parsed URL: $url');

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Signed in successfully');
        // Decode and return JSON response
        final data = jsonDecode(response.body);

        // Get token
        final token = data['token'];
        print('Token: $token');

        // Format the token into access and refresh tokens
        // Token = {accessToken: ..., refreshToken: ...}
        final accessToken = token['accessToken'];
        final refreshToken = token['refreshToken'];
        print('Access Token: $accessToken');
        print('Refresh Token: $refreshToken');

        // Store accessToken in SharedPreferences for future use
        await _storeToken(accessToken);

        return data;
      } else {
        throw Exception(
            "Failed to sign in. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during sign in: $e");
      return {};
    }
  }

  // Sign up
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$_baseUrl/api/v1/auth/sign-up');

    print('Signing up with email: $email');
    print('Username: $username');
    print('Parsed URL: $url');

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
          'username': username,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('Signed up successfully');
        // Decode and return JSON response
        final data = jsonDecode(response.body);
        print('Data: ${data["user"]}');

        return data;
      } else {
        // Format the error message to get issue
        var error = (jsonDecode(response.body)["details"]);
        error = error.toString().substring(9, error.toString().length - 3);
        _showErrorDialog(context, "Failed to sign up. \n$error");
        return {};
      }
    } catch (e) {
      print("Error during sign up: $e");
      // Format the error message to get issue
      final error = jsonDecode(e.toString());
      _showErrorDialog(context, "Error during sign up: $error");
      return {};
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Get current user info
  Future<Map<BasicUserModel, dynamic>> getCurrentUser() async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse('$_baseUrl/api/v1/auth/me');

    print('Getting current user info');
    print('Parsed URL: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode and return the current user data
        BasicUserModel user =
            BasicUserModel.fromJson(jsonDecode(response.body));
        return {user: jsonDecode(response.body)};
      } else {
        throw Exception(
            "Failed to get current user. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting current user: $e");
    }
  }

  // Sign out
  Future<http.Response> signOut() async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse('$_baseUrl/api/v1/auth/sign-out');

    print('Signing out');
    print('Parsed URL: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Remove token from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
      } else {
        throw Exception(
            "Failed to sign out. Status Code: ${response.statusCode}");
      }

      return response;
    } catch (e) {
      print("Error signing out: $e");
      return http.Response('Error signing out', 500);
    }
  }

  // Get token usage
  Future<Map<String, dynamic>> getTokenUsage() async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse('$_baseUrl/api/v1/tokens/usage');

    print('Getting token usage');
    print('Parsed URL: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode and return the token usage data
        final data = jsonDecode(response.body);

        return data;
      } else {
        throw Exception(
            "Failed to get token usage. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error getting token usage: $e");
      return {};
    }
  }

  // Do AI Chat
  Future<Map<String, dynamic>> doAIChat({
    required AiChatModel aiChat,
  }) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse('$_baseUrl/api/v1/ai-chat');

    print('Chatting with AI');
    print('Parsed URL: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          aiChat,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode and return the AI chat response
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
            "Failed to chat with AI. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error chatting with AI: $e");
      return {};
    }
  }

  // Send message
  Future<Map<String, dynamic>> sendMessage({
    required AiChatModel aiChat,
  }) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse('$_baseUrl/api/v1/message');

    print('Sending message');
    print('Parsed URL: $url');
    print('Message: $aiChat');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          aiChat,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode and return the message response
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
            "Failed to send message. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending message: $e");
      return {};
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }
}

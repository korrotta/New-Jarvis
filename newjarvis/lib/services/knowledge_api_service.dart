import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newjarvis/models/ai_bot_model.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KnowledgeApiService {
  // Base URL
  static const String _baseUrl = 'https://knowledge-api.dev.jarvis.cx';

  // Private Constructor
  KnowledgeApiService._privateConstructor();

  // Instance
  static final KnowledgeApiService instance =
      KnowledgeApiService._privateConstructor();

  // Factory Constructor
  factory KnowledgeApiService() => instance;

  // Instance of ApiService
  final ApiService _apiService = ApiService.instance;

  // Kb Token timer
  Timer? _kbTokenTimer;

  // Show error snackbar
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // Auto refresh the kb token every 30 seconds
  void autoRefreshKbToken() {
    _kbTokenTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) async {
        await refreshToken();
      },
    );
  }

  // Store the token in SharedPreferences
  Future<void> _storeToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kb_token', accessToken);
    await prefs.setString('kb_refresh_token', refreshToken);
  }

  // Get the token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('kb_token');
  }

  // Get the refresh token from SharedPreferences
  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('kb_refresh_token');
  }

  // Sign in from external client (Jarvis)
  Future<void> signIn() async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/auth/external-sign-in');
    final token = await _apiService.getTokenWithRefresh();
    final response = await http.post(
      url,
      body: {
        'token': token,
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print('Sign in knowledge API: $result');

      final kbAccessToken = result['token']['accessToken'];
      final kbRefreshToken = result['token']['refreshToken'];

      // Store the token as knowledgeApiToken
      await _storeToken(kbAccessToken, kbRefreshToken);

      return result;
    } else {
      throw Exception('Failed to sign in knowledge API');
    }
  }

  // Refresh token
  Future<void> refreshToken() async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/auth/refresh');
    final token = await _getRefreshToken();
    final response = await http.post(
      url,
      body: {
        'refreshToken': token,
      },
    );

    if (response.statusCode == 401) {
      final result = jsonDecode(response.body);
      print(result);
      print("KB Token Refreshed");

      final kbAccessToken = result['token']['accessToken'];
      final kbRefreshToken = result['token']['refreshToken'];

      // Store the token as knowledgeApiToken
      await _storeToken(kbAccessToken, kbRefreshToken);

      return result;
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  // Get Assitants
  Future<Map<String, dynamic>> getAssistants({
    required BuildContext context,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant');
    final token = await _getToken();
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(result);
      return result;
      ;
    } else {
      _showErrorSnackbar(context,
          'Failed to get assistants, Details: ${jsonDecode(response.body)}');

      print('Failed to get assistants, Details: ${jsonDecode(response.body)}');
      throw Exception('Failed to get assistants');
    }
  }

  // Create a new Assistant
  Future<Map<String, dynamic>> createAssistant(String name, String desc) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant');
    final token = await _getToken();
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'assistantName': name,
        'description': desc,
      },
    );

    if (response.statusCode == 201) {
      final result = jsonDecode(response.body);
      print(result);
      return result;
    } else {
      throw Exception(
          'Failed to create assistant, code: ${response.statusCode}, body: ${response.body}');
    }
  }

  // Delete an Assistant
  Future<Map<String, dynamic>> deleteAssistant(String assistantId) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant/$assistantId');
    final token = await _getToken();
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(result);
      return result;
    } else {
      throw Exception('Failed to delete assistant');
    }
  }
}

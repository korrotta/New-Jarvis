import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  // Store the token in SharedPreferences
  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kb_token', token);
  }

  // Get the token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('kb_token');
  }

  // Sign in from external client (Jarvis)
  Future<Map<String, dynamic>> signIn() async {
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
      print(result);
      // Store the token as knowledgeApiToken
      await _storeToken(result['token']['accessToken']);

      return result;
    } else {
      throw Exception('Failed to sign in knowledge API');
    }
  }

  // Refresh token
  Future<Map<String, dynamic>> refreshToken() async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/auth/refresh');
    final token = await _getToken();
    final response = await http.post(
      url,
      body: {
        'refreshToken': token,
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(result);
      print("Token Refreshed");
      // Store the token as knowledgeApiToken
      await _storeToken(result['accessToken']);

      return result;
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  // Get Assitants
  Future<Map<String, dynamic>> getAssistants() async {
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
    } else {
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

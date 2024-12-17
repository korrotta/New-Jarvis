import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newjarvis/services/api_service.dart';

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

      return result;
    } else {
      throw Exception('Failed to sign in knowledge API');
    }
  }

  // Get Assitants
  Future<Map<String, dynamic>> getAssistants() async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant');
    final token = await _apiService.getTokenWithRefresh();
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
}

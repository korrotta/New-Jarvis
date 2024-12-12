import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  // Sign in from external client (Jarvis)
  Future<Map<String, dynamic>> signIn(String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/kb-core/v1/auth/external-sign-in'),
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(result);
      return result;
    } else {
      throw Exception('Failed to sign in');
    }
  }
}

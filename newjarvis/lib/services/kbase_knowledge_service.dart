import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newjarvis/models/knowledge_base_model.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KnowledgeBaseApiService {
  // Base URL
  static const String _baseUrl = 'https://knowledge-api.dev.jarvis.cx';

  // Private Constructor
  KnowledgeBaseApiService._privateConstructor();

  // Instance
  static final KnowledgeBaseApiService instance =
      KnowledgeBaseApiService._privateConstructor();

  // Factory Constructor
  factory KnowledgeBaseApiService() => instance;

  // Instance of ApiService
  final ApiService _apiService = ApiService.instance;

  // Hàm sign in để lấy accessToken và refreshToken từ server kb-core
  // ignore: non_constant_identifier_names
  Future<Map<String, String>> SignInKB() async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/auth/external-sign-in');
    final systemToken = await _apiService.getTokenWithRefresh();

    try {
      final response = await http.post(
        url,
        body: {
          'token': systemToken,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        // Parse dữ liệu từ response
        final accessTokenKb = result['token']['accessToken'];
        final refreshTokenKb = result['token']['refreshToken'];

        // Lưu accessToken và refreshToken vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessTokenKb', accessTokenKb);
        await prefs.setString('refreshTokenKb', refreshTokenKb);

        print("Access Token KB: $accessTokenKb");
        print("Refresh Token KB: $refreshTokenKb");

        return {
          'accessToken': accessTokenKb,
          'refreshToken': refreshTokenKb,
        };
      } else {
        print("Failed to sign in knowledge API. Status code: ${response.statusCode}");
        print("Error: ${response.body}");
        throw Exception('Failed to sign in knowledge API');
      }
    } catch (e) {
      print("Error during sign in: $e");
      throw Exception('Failed to sign in knowledge API');
    }
  }

  // Hàm để lấy accessTokenKb từ SharedPreferences
  Future<String?> getStoredAccessTokenKb() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessTokenKb');
  }

  // Hàm để lấy refreshTokenKb từ SharedPreferences
  Future<String?> getStoredRefreshTokenKb() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshTokenKb');
  }


  // Create Knowledge API
  Future<Knowledge> createKnowledge({
  required String knowledgeName,
  required String description,
}) async {
  final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge');

  // Lấy accessToken từ SharedPreferences hoặc đăng nhập lại nếu cần
  String? token = await getStoredAccessTokenKb();
  if (token == null) {
    print("AccessToken not found. Signing in to get a new token...");
    final tokens = await SignInKB(); // Gọi hàm signIn để lấy token mới
    token = tokens['accessToken'];
  }

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'x-jarvis-guid': '',
    },
    body: jsonEncode({
      'knowledgeName': knowledgeName,
      'description': description,
    }),
  );

  if (response.statusCode == 201) {
    final result = jsonDecode(response.body);
    print("Knowledge created successfully: $result");
    // Chuyển đổi từ JSON sang model Knowledge
    return Knowledge.fromJson(result);
  } else {
    print("Failed to create knowledge. Status code: ${response.statusCode}");
    print("Error: ${response.body}");
    throw Exception('Failed to create knowledge');
  }
}


  // Get Knowledge API
  Future<List<Knowledge>> getKnowledge({
  int offset = 0,
  int limit = 20,
  String order = 'DESC',
  String orderField = 'createdAt',
  String? query,
}) async {
  final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge').replace(
    queryParameters: {
      'offset': offset.toString(),
      'limit': limit.toString(),
      'order': order,
      'order_field': orderField,
      if (query != null) 'q': query,
    },
  );

  // Lấy accessToken từ SharedPreferences hoặc đăng nhập lại nếu cần
  String? token = await getStoredAccessTokenKb();
  if (token == null) {
    print("AccessToken not found. Signing in to get a new token...");
    final tokens = await SignInKB(); // Gọi hàm signIn để lấy token mới
    token = tokens['accessToken'];
  }

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'x-jarvis-guid': '', // Thay thế nếu cần
    },
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    print("Knowledge list fetched successfully: ${result['data']}");

    // Chuyển đổi danh sách JSON sang danh sách đối tượng Knowledge
    return List<Knowledge>.from(
      (result['data'] as List).map((item) => Knowledge.fromJson(item)),
    );
  } else {
    print("Failed to fetch knowledge. Status code: ${response.statusCode}");
    print("Error: ${response.body}");
    throw Exception('Failed to fetch knowledge');
  }
}


  // Delete Knowledge API
  Future<void> deleteKnowledge(String id) async {
  final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge/$id');

  // Lấy accessToken từ SharedPreferences hoặc đăng nhập lại nếu cần
  String? token = await getStoredAccessTokenKb();
  if (token == null) {
    print("AccessToken not found. Signing in to get a new token...");
    final tokens = await SignInKB(); // Gọi hàm signIn để lấy token mới
    token = tokens['accessToken'];
  }

  final response = await http.delete(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'x-jarvis-guid': '', // Thay thế giá trị thực tế nếu cần
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 204) {
    print("Knowledge deleted successfully: ID $id");
  } else {
    print("Failed to delete knowledge. Status code: ${response.statusCode}");
    print("Error: ${response.body}");
    throw Exception('Failed to delete knowledge');
  }
}

// Hàm để chỉnh sửa Knowledge
Future<Knowledge> updateKnowledge({
  required String id,
  required String knowledgeName,
  String? description,
}) async {
  final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge/$id');

  // Lấy accessToken từ SharedPreferences hoặc đăng nhập lại nếu cần
  String? token = await getStoredAccessTokenKb();
  if (token == null) {
    print("AccessToken not found. Signing in to get a new token...");
    final tokens = await SignInKB(); // Gọi hàm signIn để lấy token mới
    token = tokens['accessToken'];
  }

  final response = await http.patch(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'x-jarvis-guid': '',
    },
    body: jsonEncode({
      'knowledgeName': knowledgeName,
      if (description != null) 'description': description,
    }),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    print("Knowledge updated successfully: $result");

    // Sử dụng model Knowledge để parse response
    return Knowledge.fromJson(result);
  } else {
    print("Failed to update knowledge. Status code: ${response.statusCode}");
    print("Error: ${response.body}");
    throw Exception('Failed to update knowledge');
  }
}







}

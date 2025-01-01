import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:newjarvis/models/unit_of_knowledgebase_model.dart';
import 'package:newjarvis/services/kbase_knowledge_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KnowledgeBaseUnitApiService {
  // Base URL
  static const String _baseUrl = 'https://knowledge-api.dev.jarvis.cx';

  final KnowledgeBaseApiService _knowledgeApiService = KnowledgeBaseApiService();

  // Private Constructor
  KnowledgeBaseUnitApiService._privateConstructor();

  // Instance
  static final KnowledgeBaseUnitApiService instance =
      KnowledgeBaseUnitApiService._privateConstructor();

  // Factory Constructor
  factory KnowledgeBaseUnitApiService() => instance;
  

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


  // Add Unit Website API
  Future<Unit> addUnitWebsite({
    required String knowledgeId,
    required String unitName,
    required String webUrl,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge/$knowledgeId/web');

    // Lấy accessToken từ SharedPreferences hoặc đăng nhập lại nếu cần
    String? token = await getStoredAccessTokenKb();
    if (token == null) {
      print("AccessToken not found. Signing in to get a new token...");
      final tokens = await _knowledgeApiService.SignInKB(); // Gọi hàm signIn để lấy token mới
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
        'unitName': unitName,
        'webUrl': webUrl,
      }),
    );

    if (response.statusCode == 201) {
      final result = jsonDecode(response.body);
      print("Unit Website added successfully: $result");

      // Trả về đối tượng Unit
      return Unit.fromJson(result);
    } else {
      print("Failed to add Unit Website. Status code: ${response.statusCode}");
      print("Error: ${response.body}");
      throw Exception('Failed to add Unit Website');
    }
  }


  // Add Unit Slack API
  Future<Unit> addUnitSlack({
    required String knowledgeId,
    required String unitName,
    required String slackWorkspace,
    required String slackBotToken,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge/$knowledgeId/slack');

    // Lấy accessToken từ SharedPreferences hoặc đăng nhập lại nếu cần
    String? token = await getStoredAccessTokenKb();
    if (token == null) {
      print("AccessToken not found. Signing in to get a new token...");
      final tokens = await _knowledgeApiService.SignInKB(); // Gọi hàm signIn để lấy token mới
      token = tokens['accessToken'];
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'x-jarvis-guid': '', // Thay thế giá trị nếu cần
      },
      body: jsonEncode({
        'unitName': unitName,
        'slackWorkspace': slackWorkspace,
        'slackBotToken': slackBotToken,
      }),
    );

    if (response.statusCode == 201) {
      final result = jsonDecode(response.body);
      print("Slack unit added successfully: $result");

      // Trả về đối tượng Unit
      return Unit.fromJson(result);
    } else {
      print("Failed to add Slack unit. Status code: ${response.statusCode}");
      print("Error: ${response.body}");
      throw Exception('Failed to add Slack unit');
    }
  }


  // Add Unit Confluence API
  Future<Unit> addUnitConfluence({
    required String knowledgeId,
    required String unitName,
    required String wikiPageUrl,
    required String confluenceUsername,
    required String confluenceAccessToken,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge/$knowledgeId/confluence');

    // Lấy accessToken từ SharedPreferences hoặc đăng nhập lại nếu cần
    String? token = await getStoredAccessTokenKb();
    if (token == null) {
      print("AccessToken not found. Signing in to get a new token...");
      final tokens = await _knowledgeApiService.SignInKB(); // Gọi hàm signIn để lấy token mới
      token = tokens['accessToken'];
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'x-jarvis-guid': '', // Thay thế giá trị thực tế nếu cần
      },
      body: jsonEncode({
        'unitName': unitName,
        'wikiPageUrl': wikiPageUrl,
        'confluenceUsername': confluenceUsername,
        'confluenceAccessToken': confluenceAccessToken,
      }),
    );

    if (response.statusCode == 201) {
      final result = jsonDecode(response.body);
      print("Unit Confluence added successfully: $result");

      // Trả về đối tượng Unit
      return Unit.fromJson(result);
    } else {
      print("Failed to add Unit Confluence. Status code: ${response.statusCode}");
      print("Error: ${response.body}");
      throw Exception('Failed to add Unit Confluence');
    }
  }


  // Get Units of Knowledge API
  Future<List<Unit>> getUnitsOfKnowledge({
    required String knowledgeId,
    int offset = 0,
    int limit = 20,
    String order = 'DESC',
    String orderField = 'createdAt',
    String? query,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge/$knowledgeId/units').replace(
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
      final tokens = await _knowledgeApiService.SignInKB(); // Gọi hàm signIn để lấy token mới
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
      print("Units of Knowledge fetched successfully: ${result['data']}");

      // Chuyển đổi từ JSON sang danh sách Unit model
      return (result['data'] as List).map((unitJson) => Unit.fromJson(unitJson)).toList();
    } else {
      print("Failed to fetch units. Status code: ${response.statusCode}");
      print("Error: ${response.body}");
      throw Exception('Failed to fetch units');
    }
  }


  // uploadLocalFile API
  Future<Unit> uploadLocalFile({
    required String knowledgeId,
    required String filePath,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge/$knowledgeId/local-file');

    // Lấy accessToken từ SharedPreferences hoặc đăng nhập lại nếu cần
    String? token = await getStoredAccessTokenKb();
    if (token == null) {
      print("AccessToken not found. Signing in to get a new token...");
      final tokens = await _knowledgeApiService.SignInKB(); // Gọi hàm signIn để lấy token mới
      token = tokens['accessToken'];
    }

    // Kiểm tra MIME type
    final mimeType = lookupMimeType(filePath);
    if (mimeType == null) {
      throw Exception('Unable to determine MIME type for the file.');
    }

    final allowedMimeTypes = [
      'text/x-c', 'text/x-c++', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'text/html', 'text/x-java', 'application/json', 'text/markdown',
      'application/pdf', 'text/x-php', 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'text/x-python', 'text/x-ruby', 'text/x-tex', 'text/plain',
    ];

    if (!allowedMimeTypes.contains(mimeType)) {
      throw Exception('File type not supported: $mimeType');
    }

    // Tạo request upload file
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Authorization': 'Bearer $token',
        'x-jarvis-guid': '',
      })
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
          contentType: MediaType.parse(mimeType),
        ),
      );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final result = jsonDecode(response.body);
        print("File uploaded successfully: $result");

        // Chuyển đổi từ JSON sang Unit model
        return Unit.fromJson(result);
      } else {
        print("Failed to upload file. Status code: ${response.statusCode}");
        print("Error: ${response.body}");
        throw Exception('Failed to upload file');
      }
    } catch (e) {
      print("Exception occurred during file upload: $e");
      throw Exception('An error occurred while uploading the file.');
    }
  }

  // Update Unit Status API
  Future<Unit> setUnitStatus({
    required String unitId,
    required bool status,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge/units/$unitId/status');

    // Lấy accessToken từ SharedPreferences hoặc đăng nhập lại nếu cần
    String? token = await getStoredAccessTokenKb();
    if (token == null) {
      print("AccessToken not found. Signing in to get a new token...");
      final tokens = await _knowledgeApiService.SignInKB(); // Gọi hàm signIn để lấy token mới
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
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print("Unit status updated successfully: $result");

      // Trả về đối tượng Unit
      return Unit.fromJson(result);
    } else {
      print("Failed to update unit status. Status code: ${response.statusCode}");
      print("Error: ${response.body}");
      throw Exception('Failed to update unit status');
    }
  }

  Future<void> deleteUnit(String unitId, String knowledgeId) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/knowledge/$knowledgeId/units/$unitId');

    // Lấy accessToken từ SharedPreferences hoặc đăng nhập lại nếu cần
    String? token = await getStoredAccessTokenKb();
    if (token == null) {
      print("AccessToken not found. Signing in to get a new token...");
      final tokens = await _knowledgeApiService.SignInKB(); // Gọi hàm signIn để lấy token mới
      token = tokens['accessToken'];
    }

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'x-jarvis-guid': '',
      },
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      print("Unit deleted successfully");
    } else {
      print("Failed to delete unit. Status code: ${response.statusCode}");
      print("Error: ${response.body}");
      throw Exception('Failed to delete unit');
    }
  }
}
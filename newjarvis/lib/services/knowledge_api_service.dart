import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newjarvis/enums/order.dart';
import 'package:newjarvis/models/assistant/ai_bot_model.dart';
import 'package:newjarvis/models/assistant/assistant_knowledge_model.dart';
import 'package:newjarvis/models/assistant/assistant_thread_message_model.dart';
import 'package:newjarvis/models/assistant/assistant_thread_model.dart';
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
  Future<List<AiBotModel>> getAssistants({
    required BuildContext context,
    String? query,
    Order? order,
    String? orderField,
    int? offset,
    int? limit,
    bool? isFavorite,
    bool? isPublished,
    bool? isAll,
  }) async {
    if (isAll == false || isAll == null) {
      final _queryParameters = {
        'q': query ?? '',
        'order': order ?? 'ASC',
        'order_field': orderField ?? 'createdAt',
        'offset': offset?.toString() ?? '0',
        'limit': limit?.toString() ?? '10',
        'is_favorite': isFavorite.toString(),
        'is_published': isPublished.toString(),
      };

      final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant').replace(
        queryParameters: _queryParameters,
      );

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
        final data = result['data'] as List;
        final List<AiBotModel> assistants =
            data.map((e) => AiBotModel.fromJson(e)).toList();

        final metadata = result['metadata'];
        return assistants;
      } else {
        _showErrorSnackbar(context,
            'Failed to get assistants, Details: ${jsonDecode(response.body)}');

        print(
            'Failed to get assistants, Details: ${jsonDecode(response.body)}');
        throw Exception('Failed to get assistants');
      }
    } else {
      final _queryParameters = {
        'q': query ?? '',
        'order': order ?? 'ASC',
        'order_field': orderField ?? 'createdAt',
        'offset': offset?.toString() ?? '0',
        'limit': limit?.toString() ?? '10',
      };

      final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant').replace(
        queryParameters: _queryParameters,
      );

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
        final data = result['data'] as List;
        final List<AiBotModel> assistants =
            data.map((e) => AiBotModel.fromJson(e)).toList();

        final metadata = result['metadata'];
        return assistants;
      } else {
        _showErrorSnackbar(context,
            'Failed to get assistants, Details: ${jsonDecode(response.body)}');

        print(
            'Failed to get assistants, Details: ${jsonDecode(response.body)}');
        throw Exception('Failed to get assistants');
      }
    }
  }

  // Create a new Assistant
  Future<Map<String, dynamic>> createAssistant({
    required BuildContext context,
    required String? name,
    String? desc,
    String? instructions,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant');
    final token = await _getToken();
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'assistantName': name,
        'description': desc ?? '',
        'instructions': instructions ?? '',
      },
    );

    if (response.statusCode == 201) {
      final result = jsonDecode(response.body);
      print(result);
      return result;
    } else {
      _showErrorSnackbar(context,
          'Failed to create assistant, code: ${response.statusCode}, body: ${response.body}');
      print(
          'Failed to create assistant, code: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to create assistant');
    }
  }

  // Delete an Assistant
  Future<bool> deleteAssistant({
    required BuildContext context,
    required String? assistantId,
  }) async {
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
      _showErrorSnackbar(context,
          'Failed to delete assistant, code: ${response.statusCode}, body: ${response.body}');
      print(
          'Failed to delete assistant, code: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to delete assistant');
    }
  }

  // Favorite an Assistant
  Future<AiBotModel> favoriteAssistant({
    required BuildContext context,
    required String assistantId,
  }) async {
    final url =
        Uri.parse('$_baseUrl/kb-core/v1/ai-assistant/$assistantId/favorite');
    final token = await _getToken();
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      final result = jsonDecode(response.body);
      print(result);
      return AiBotModel.fromJson(result);
    } else {
      _showErrorSnackbar(context,
          'Failed to favorite assistant, code: ${response.statusCode}, body: ${response.body}');
      print(
          'Failed to favorite assistant, code: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to favorite assistant');
    }
  }

  // Update an Assistant
  Future<AiBotModel> updateAssistant({
    required BuildContext context,
    required String assistantId,
    required String? name,
    String? desc,
    String? instructions,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant/$assistantId');
    final token = await _getToken();
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'assistantName': name,
        'description': desc ?? '',
        'instructions': instructions ?? '',
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(result);
      return AiBotModel.fromJson(result);
    } else {
      print(
          'Failed to update assistant, code: ${response.statusCode}, body: ${response.body}');
      return AiBotModel.error(
          'Failed to update assistant, code: ${response.statusCode}');
    }
  }

  // Get Assistant by ID
  Future<AiBotModel> getAssistantById({
    required BuildContext context,
    required String assistantId,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant/$assistantId');
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
      return AiBotModel.fromJson(result);
    } else {
      print(
          'Failed to get assistant by ID, Details: ${jsonDecode(response.body)}');
      throw Exception('Failed to get assistant by ID');
    }
  }

  // Create Thread for Assistant
  Future<AssistantThreadModel> createThread({
    required BuildContext context,
    required String assistantId,
    String? firstMessage,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant/thread');
    final token = await _getToken();
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'assistantId': assistantId,
        'firstMessage': firstMessage ?? '',
      },
    );

    if (response.statusCode == 201) {
      final result = jsonDecode(response.body);
      print(result);

      return AssistantThreadModel.fromJson(result);
      ;
    } else {
      print(
          'Failed to create thread, code: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to create thread');
    }
  }

  // Ask Assistant
  Future<String> askAssistant({
    required BuildContext context,
    required String assistantId,
    required String? openAiThreadId,
    required String message,
    required String additionalInstruction,
  }) async {
    final url = Uri.parse('$_baseUrl/kb-core/v1/ai-assistant/$assistantId/ask');
    final token = await _getToken();
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'openAiThreadId': openAiThreadId,
        'message': message,
        'additionalInstruction': additionalInstruction,
      },
    );

    if (response.statusCode != 401) {
      final result = response.body;
      print('Ask Assistant: $result');
      return result;
    } else {
      print(
          'Failed to ask assistant, code: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to ask assistant');
    }
  }

  // Get all threads from assistantId
  Future<List<AssistantThreadModel>> getThreads({
    required BuildContext context,
    required String assistantId,
  }) async {
    final url =
        Uri.parse('$_baseUrl/kb-core/v1/ai-assistant/$assistantId/threads');
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
      final data = result['data'] as List;

      final List<AssistantThreadModel> threads =
          data.map((e) => AssistantThreadModel.fromJson(e)).toList();

      final metadata = result['meta'];

      return threads;
    } else {
      print(
          'Failed to get threads, code: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to get threads');
    }
  }

  // Retreive messages from thread /kb-core/v1/ai-assistant/thread/{openAiThreadId}/messages
  Future<List<AssistantThreadMessageModel>> getMessages({
    required BuildContext context,
    required String openAiThreadId,
  }) async {
    List<AssistantThreadMessageModel> messages = [];
    final url = Uri.parse(
        '$_baseUrl/kb-core/v1/ai-assistant/thread/$openAiThreadId/messages');

    final token = await _getToken();
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);

      messages =
          result.map((e) => AssistantThreadMessageModel.fromJson(e)).toList();

      return messages;
    } else {
      throw Exception('Failed to get messages $response');
    }
  }

  // Import Knowledge to Assistant
  Future<bool> importKnowledge({
    required BuildContext context,
    required String assistantId,
    required String knowledgeId,
  }) async {
    final url = Uri.parse(
        '$_baseUrl/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId');
    final token = await _getToken();
    final response = await http.post(
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
      print(
          'Failed to import knowledge, code: ${response.statusCode}, body: ${response.body}');
      return false;
    }
  }

  // Remove Knowledge from Assistant
  Future<bool> removeKnowledge({
    required BuildContext context,
    required String assistantId,
    required String knowledgeId,
  }) async {
    final url = Uri.parse(
        '$_baseUrl/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId');
    final token = await _getToken();
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(
          'Remove KnowledgeId: $knowledgeId from AssistantId: $assistantId with result: $result');
      return result;
    } else {
      print(
          'Failed to remove knowledge, code: ${response.statusCode}, body: ${response.body}');
      return false;
    }
  }

  // Get Knowledge in Assistant
  Future<List<AssistantKnowledgeModel>> getKnowledgeAssistant({
    required BuildContext context,
    required String assistantId,
  }) async {
    final url =
        Uri.parse('$_baseUrl/kb-core/v1/ai-assistant/$assistantId/knowledges');
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
      final List<dynamic> data = result['data'];

      final List<AssistantKnowledgeModel> knowledges = data
          .map((e) =>
              AssistantKnowledgeModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return knowledges;
    } else {
      print(
          'Failed to get knowledge in assistant, code: ${response.statusCode}, body: ${response.body}');
      return [];
    }
  }
}

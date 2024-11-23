import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:newjarvis/models/ai_chat_model.dart';
import 'package:newjarvis/models/assistant_model.dart';
import 'package:newjarvis/models/basic_user_model.dart';
import 'package:newjarvis/models/chat_response_model.dart';
import 'package:newjarvis/models/conversation_history_item_model.dart';
import 'package:newjarvis/models/conversation_item_model.dart';
import 'package:newjarvis/models/geo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL
  static const String _baseUrl = 'https://api.dev.jarvis.cx';

  // Private Constructor
  ApiService._privateConstructor();

  // Instance
  static final ApiService instance = ApiService._privateConstructor();

  // Factory Constructor
  factory ApiService() => instance;

  // Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: const Text('Error'),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Signed in successfully');
        // Decode and return JSON response
        final data = jsonDecode(response.body);

        // Get token
        final token = data['token'];
        print('Token: $token');

        // Format the token into access and refresh tokens
        final accessToken = token['accessToken'];
        final refreshToken = token['refreshToken'];

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

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
          'username': username,
        },
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
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

  // Get current user info
  Future<BasicUserModel> getCurrentUser(
    BuildContext context,
  ) async {
    BasicUserModel user = BasicUserModel(
      id: '',
      email: '',
      username: '',
      geo: Geo(
        city: '',
        region: '',
      ),
      roles: [],
    );

    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse('$_baseUrl/api/v1/auth/me');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode and return the current user data
        final data = jsonDecode(response.body);
        user = BasicUserModel.fromMap(data);
        return user;
      } else {
        _showErrorSnackbar(
            context, "Failed to get current user: ${response.statusCode}");
        return user;
      }
    } catch (e) {
      _showErrorSnackbar(context, "Error getting current user: $e");
      return user;
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
          'Content-Type': 'application/json',
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
          'Content-Type': 'application/json',
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
          'Content-Type': 'application/json',
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
  Future<ChatResponseModel> sendMessage({
    required BuildContext context,
    required AiChatModel aiChat,
  }) async {
    ChatResponseModel chatResponse = ChatResponseModel(
      id: '',
      message: '',
      remainingUsage: 0,
    );

    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse('$_baseUrl/api/v1/ai-chat/messages');

    print('Message: $aiChat');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(aiChat.toJson()),
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode and return the message response
        final data = jsonDecode(response.body);

        chatResponse = ChatResponseModel.fromJson(data);

        return chatResponse;
      } else {
        _showErrorSnackbar(context,
            "Failed to send message. Status Code: ${response.statusCode}");
        return chatResponse;
      }
    } catch (e) {
      _showErrorSnackbar(context, "Error sending message: $e");
      return chatResponse;
    }
  }

  // Get conversations
  Future<List<ConversationItemModel>> getConversations({
    required BuildContext context,
    required String? cursor,
    required int? limit,
    required AssistantModel? assistant,
  }) async {
    final token = await _getToken();

    final assistantId = assistant?.id;
    final assistantModel = assistant?.model;

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse('$_baseUrl/api/v1/ai-chat/conversations').replace(
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        if (limit != null) 'limit': limit.toString(),
        if (assistantId != null) 'assistantId': assistantId,
        'assistantModel': assistantModel,
      },
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response body conversations: ${response.body}');

      if (response.statusCode == 200) {
        // Decode and return the conversation
        final data = jsonDecode(response.body);

        String cursor = data['cursor'];
        bool hasMore = data['has_more'];
        int limit = data['limit'];
        final List<dynamic> items = data['items'] ?? [];

        print('Cursor: $cursor');
        print('Has more: $hasMore');
        print('Limit: $limit');
        print('Items: $items');

        List<ConversationItemModel> conversations = items.map((item) {
          return ConversationItemModel.fromJson(item);
        }).toList();

        return conversations;
      } else {
        _showErrorSnackbar(context,
            "Failed to get conversation. Status Code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      _showErrorSnackbar(context, "Error getting conversation: $e");
      return [];
    }
  }

  // Get conversation history /api/v1/ai-chat/conversations/{conversationId}/messages
  Future<List<ConversationHistoryItemModel>> getConversationHistory({
    required BuildContext context,
    required String conversationId,
    required String? cursor,
    required int? limit,
    required AssistantModel? assistant,
  }) async {
    final token = await _getToken();

    final assistantId = assistant?.id;
    final assistantModel = assistant?.model;

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse(
            '$_baseUrl/api/v1/ai-chat/conversations/$conversationId/messages')
        .replace(
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        if (limit != null) 'limit': limit.toString(),
        if (assistantId != null) 'assistantId': assistantId,
        'assistantModel': assistantModel,
      },
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode and return the conversation history
        final data = jsonDecode(response.body);

        String cursor = data['cursor'];
        bool hasMore = data['has_more'];
        int limit = data['limit'];
        final items = data['items'];

        print('Cursor: $cursor');
        print('Has more: $hasMore');
        print('Limit: $limit');
        print('Items: $items');

        List<ConversationHistoryItemModel> conversationHistory = [];
        conversationHistory = items
            .map<ConversationHistoryItemModel>(
                (item) => ConversationHistoryItemModel.fromJson(item))
            .toList();

        return conversationHistory;
      } else {
        _showErrorSnackbar(context,
            "Failed to get conversation history. Status Code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      _showErrorSnackbar(context, "Error getting conversation history: $e");
      return [];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  // Get Prompts
  Future<List<Map<String, dynamic>>> getPrompts({
    required BuildContext context,
    String query = '',
    int offset = 0,
    int limit = 20,
    bool isFavorite = false,
    bool isPublic = true,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }
    print('==token: $token');

    final url = Uri.parse(
        '$_baseUrl/api/v1/prompts?query=$query&offset=$offset&limit=$limit&isFavorite=$isFavorite&isPublic=$isPublic');

    print('Fetching prompts from URL: $url');

    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'x-jarvis-guid': '', // Replace with a valid GUID if required
      };

      final request = http.Request('GET', url);
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');

        final data = jsonDecode(responseBody);

        // Assuming the response contains a list of prompts
        final prompts = List<Map<String, dynamic>>.from(data['items'] ?? []);
        return prompts;
      } else {
        _showErrorSnackbar(context,
            "Failed to fetch prompts. Status Code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching prompts: $e");
      _showErrorSnackbar(context, "Error fetching prompts: $e");
      return [];
    }
  }

  // Add this method to your ApiService class
  Future<Map<String, dynamic>> createPrompt({
    required BuildContext context,
    required String title,
    required String content,
    required String description,
    required String category,
    required String language,
    required bool isPublic,
  }) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse('$_baseUrl/api/v1/prompts');

    print('Creating prompt at URL: $url');

    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        "title": title,
        "content": content,
        "description": description,
        "category": category,
        "language": language,
        "isPublic": isPublic,
      });

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        // Decode and return the response
        final data = jsonDecode(response.body);
        return data;
      } else {
        _showErrorSnackbar(context,
            "Failed to create prompt. Status Code: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error creating prompt: $e");
      _showErrorSnackbar(context, "Error creating prompt: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> updatePrompt({
    required BuildContext context,
    required String promptId,
    required String title,
    required String content,
    required String description,
    required String category,
    required String language,
    required bool isPublic,
  }) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found. Please sign in.');
    }

    final url = Uri.parse('$_baseUrl/api/v1/prompts/$promptId');

    print('Updating prompt at URL: $url');

    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        "title": title,
        "content": content,
        "description": description,
        "category": category,
        "language": language,
        "isPublic": isPublic,
      });

      final response = await http.patch(
        url,
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode and return the response
        final data = jsonDecode(response.body);
        return data;
      } else {
        _showErrorSnackbar(context,
            "Failed to update prompt. Status Code: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error updating prompt: $e");
      _showErrorSnackbar(context, "Error updating prompt: $e");
      return {};
    }
  }

  Future<void> deletePrompt({
    required BuildContext context,
    required String promptId,
  }) async {
    final String? token = await _getToken(); // Get the token dynamically

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication token not found. Please log in again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String url = '$_baseUrl/api/v1/prompts/$promptId'; // Construct URL

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prompt deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to delete prompt. Error: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting prompt: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

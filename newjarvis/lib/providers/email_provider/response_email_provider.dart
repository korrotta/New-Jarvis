import 'package:flutter/material.dart';
import 'package:newjarvis/models/email/response_email_model.dart';
import 'package:newjarvis/services/api_service.dart';


class EmailProvider with ChangeNotifier {
  bool _isLoading = false;
  EmailResponseModel? _emailResponse;

  bool get isLoading => _isLoading;
  EmailResponseModel? get emailResponse => _emailResponse;

  final ApiService _apiService = ApiService();

  Future<void> generateEmail({
    required String model,
    required String assistantId,
    required String email,
    required String action,
    required String mainIdea,
    required List<Map<String, String>> context,
    required String subject,
    required String sender,
    required String receiver,
    required String length,
    required String formality,
    required String tone,
    required String language,
    required BuildContext contextUI,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.responseEmail(
        model: model,
        assistantId: assistantId,
        email: email,
        action: action,
        mainIdea: mainIdea,
        context: context,
        subject: subject,
        sender: sender,
        receiver: receiver,
        length: length,
        formality: formality,
        tone: tone,
        language: language,
        contextUI: contextUI,
      );

      _emailResponse = EmailResponseModel.fromJson(response);
    } catch (e) {
      print("Error generating email: $e");
      _emailResponse = null;
     
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

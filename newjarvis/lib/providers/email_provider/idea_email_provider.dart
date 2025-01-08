import 'package:flutter/material.dart';
import 'package:newjarvis/models/email/idea_email_model.dart';
import 'package:newjarvis/services/api_service.dart';


class EmailDraftIdeaProvider with ChangeNotifier {
  bool _isLoading = false;
  EmailIdeaResponseModel? _emailResponse;

  bool get isLoading => _isLoading;
  EmailIdeaResponseModel? get emailResponse => _emailResponse;

  final ApiService _apiService = ApiService();

  Future<void> generateEmailIdea({
    required String model,
    required String assistantId,
    required String email,
    required String action,
    required List<Map<String, String>> context,
    required String subject,
    required String sender,
    required String receiver,
    required String language,
    required BuildContext contextUI,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.responseDraftIdeaEmail(
        model: model,
        assistantId: assistantId,
        email: email,
        action: action,
        context: context,
        subject: subject,
        sender: sender,
        receiver: receiver,
        language: language,
        contextUI: contextUI,
      );

      _emailResponse = EmailIdeaResponseModel.fromJson(response);
    } catch (e) {
      print("Error generating email: $e");
      _emailResponse = null;
     
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

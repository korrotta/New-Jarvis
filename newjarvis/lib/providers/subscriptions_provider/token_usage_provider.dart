
import 'package:flutter/material.dart';
import 'package:newjarvis/models/subscriptions/token_usage_model.dart';
import 'package:newjarvis/services/api_service.dart';

class UsageProvider extends ChangeNotifier {
  Usage? _usage;
  bool _isLoading = false;

  Usage? get usage => _usage;
  bool get isLoading => _isLoading;

  final ApiService  _apiService = ApiService();

  Future<void> fetchUsage(
      {required BuildContext context}
  ) async {

    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.getUsage(context: context);
      _usage = Usage.fromJson(response);

    } catch (e) {
      print('Error fetching usage: $e');
      _usage = null;


    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}

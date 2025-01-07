
import 'package:flutter/material.dart';
import 'package:newjarvis/models/subscriptions/subscription_model.dart';
import 'package:newjarvis/services/api_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionModel? _subs;
  bool _isLoading = false;

  SubscriptionModel? get subs => _subs;
  bool get isLoading => _isLoading;

  final ApiService  _apiService = ApiService();

  Future<void> getSubscriptions(
      {required BuildContext context}
  ) async {

    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.getSubscriptions(context: context);
      _subs = SubscriptionModel.fromJson(response);

    } catch (e) {
      print('Error fetching usage: $e');
      _subs = null;


    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}

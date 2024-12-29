import 'package:flutter/material.dart';
import 'package:newjarvis/models/basic_user_model.dart';
import 'package:newjarvis/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  BasicUserModel? _currentUser;
  bool _isLoading = true;

  BasicUserModel? get currentUser => _currentUser;

  bool get isLoading => _isLoading;

  AuthProvider(BuildContext context) {
    _initializeUser(context);
  }

  Future<bool> isLoggedIn() async {
    return await apiService.isLoggedIn();
  }

  Future<void> _initializeUser(BuildContext context) async {
    bool isLoggedIn = await apiService.isLoggedIn();
    if (isLoggedIn) {
      try {
        _currentUser = await apiService.getCurrentUser(context);
      } catch (e) {
        print('Error: $e');
      }
    } else {
      _currentUser = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    await apiService.signOut();
    _currentUser = null;

    notifyListeners();
  }
}

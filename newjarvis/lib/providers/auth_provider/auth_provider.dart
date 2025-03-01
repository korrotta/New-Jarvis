import 'package:flutter/material.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/models/user/basic_user_model.dart';
import 'package:newjarvis/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
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
    await apiService.signOut(context);
    _currentUser = null;
    RouteController.navigateReplacementNamed(RouteController.auth);
    notifyListeners();
  }
}

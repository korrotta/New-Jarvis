import 'package:newjarvis/models/user_model.dart';

class ApiModel {
  final String baseUrl;
  final String apiKey;
  UserModel user;

  ApiModel({
    required this.baseUrl,
    required this.apiKey,
    required this.user,
  });
}

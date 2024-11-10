// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String createdAt;
  dynamic createdBy;
  dynamic deletedAt;
  String email;
  dynamic hashedRefreshToken;
  String id;
  bool isActive;
  List<String> roles;
  String updatedAt;
  dynamic updatedBy;
  List<String> usedAuthOptions;
  String username;

  UserModel({
    required this.createdAt,
    this.createdBy,
    this.deletedAt,
    required this.email,
    this.hashedRefreshToken,
    required this.id,
    required this.isActive,
    required this.roles,
    required this.updatedAt,
    this.updatedBy,
    required this.usedAuthOptions,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdAt': createdAt,
      'createdBy': createdBy,
      'deletedAt': deletedAt,
      'email': email,
      'hashedRefreshToken': hashedRefreshToken,
      'id': id,
      'isActive': isActive,
      'roles': roles,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'usedAuthOptions': usedAuthOptions,
      'username': username,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      createdAt: map['createdAt'] as String,
      createdBy: map['createdBy'] != null ? map['createdBy'] as dynamic : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as dynamic : null,
      email: map['email'] as String,
      hashedRefreshToken: map['hashedRefreshToken'] != null
          ? map['hashedRefreshToken'] as dynamic
          : null,
      id: map['id'] as String,
      isActive: map['isActive'] as bool,
      roles: List<String>.from(
          (map['roles'] as List).map((item) => item as String)),
      updatedAt: map['updatedAt'] as String,
      updatedBy: map['updatedBy'] != null ? map['updatedBy'] as dynamic : null,
      usedAuthOptions: List<String>.from(
          (map['usedAuthOptions'] as List).map((item) => item as String)),
      username: map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

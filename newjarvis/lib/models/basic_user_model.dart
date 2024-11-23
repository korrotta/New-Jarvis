// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BasicUserModel {
  String? id, email, username;
  List<String> roles;

  BasicUserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.roles,
  });

  String get getId => id!;
  String get getEmail => email!;
  String get getUsername => username!;
  List<String> get getRoles => roles;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'roles': roles,
    };
  }

  factory BasicUserModel.fromMap(Map<String, dynamic> map) {
    return BasicUserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      roles: List<String>.from(
          (map['roles'] as List).map((item) => item as String)),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'BasicUserModel(id: $id, email: $email, username: $username, roles: $roles)';
  }

  factory BasicUserModel.fromJson(String source) =>
      BasicUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

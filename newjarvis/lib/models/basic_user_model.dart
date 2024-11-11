// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BasicUserModel {
  String id, email, username, geo;
  List<String> roles;

  BasicUserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.geo,
    required this.roles,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'geo': geo,
      'roles': roles,
    };
  }

  factory BasicUserModel.fromMap(Map<String, dynamic> map) {
    return BasicUserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      geo: map['geo'] as String,
      roles: List<String>.from(
          (map['roles'] as List).map((item) => item as String)),
    );
  }

  String toJson() => json.encode(toMap());

  factory BasicUserModel.fromJson(String source) =>
      BasicUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

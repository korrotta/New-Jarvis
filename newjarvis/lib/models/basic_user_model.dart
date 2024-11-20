// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:newjarvis/models/geo_model.dart';

class BasicUserModel {
  String id, email, username;
  Geo geo;
  List<String> roles;

  BasicUserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.geo,
    required this.roles,
  });

  String get getId => id;
  String get getEmail => email;
  String get getUsername => username;
  Geo get getGeo => geo;
  List<String> get getRoles => roles;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'geo': geo.toMap(),
      'roles': roles,
    };
  }

  factory BasicUserModel.fromMap(Map<String, dynamic> map) {
    return BasicUserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      geo: Geo.fromMap(map['geo'] as Map<String, dynamic>),
      roles: List<String>.from(
          (map['roles'] as List).map((item) => item as String)),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'BasicUserModel(id: $id, email: $email, username: $username, geo: $geo, roles: $roles)';
  }

  factory BasicUserModel.fromJson(String source) =>
      BasicUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

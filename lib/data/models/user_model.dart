import 'package:sport_flutter/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.id, required super.username, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // The fix is to convert the integer ID from JSON to a String.
      id: json['userId'].toString(),
      username: json['username'] ?? '', // Provide a default value if null
      email: json['email'] ?? '', // Provide a default value if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}

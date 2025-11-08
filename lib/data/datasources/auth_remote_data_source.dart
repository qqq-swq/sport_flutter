
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_flutter/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<void> register(String username, String password, String email, String code);
  Future<void> sendVerificationCode(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  final String _baseUrl = "http://192.168.4.140:3000/api/auth";

  AuthRemoteDataSourceImpl({required this.client, required this.sharedPreferences});

  @override
  Future<void> sendVerificationCode(String email) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/send-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      // Provide a more specific error message from the backend response
      final errorBody = jsonDecode(response.body);
      throw Exception('Failed to send code: ${errorBody['error'] ?? response.body}');
    }
  }

  @override
  Future<void> register(String username, String password, String email, String code) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'code': code,
      }),
    );

    if (response.statusCode != 201) {
      final errorBody = jsonDecode(response.body);
      throw Exception('Failed to register: ${errorBody['error'] ?? response.body}');
    }
  }

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await sharedPreferences.setString('authToken', token);
      return UserModel.fromJson(data['user']);
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception('Failed to login: ${errorBody['error'] ?? response.body}');
    }
  }
}

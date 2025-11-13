
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sport_flutter/data/models/user_model.dart';

// Centralized base URL for the entire application
const String _serverIp = "192.168.4.140"; // YOUR ACTUAL SERVER IP
const String _serverPort = "3000";
const String _baseUrl = "http://$_serverIp:$_serverPort";

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<void> register(String username, String email, String password, String code);
  Future<void> sendVerificationCode(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  
  // A static getter to allow other data sources to use the same base URL
  static String getBaseApiUrl() => "$_baseUrl/api";

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<void> sendVerificationCode(String email) async {
    final response = await client.post(
      Uri.parse('${getBaseApiUrl()}/auth/send-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body);
      throw Exception('Failed to send code: ${errorBody['error'] ?? response.body}');
    }
  }

  @override
  Future<void> register(String username, String email, String password, String code) async {
    final response = await client.post(
      Uri.parse('${getBaseApiUrl()}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'code': code,
      }),
    );

    if (response.statusCode != 201) {
      final errorBody = jsonDecode(response.body);
      throw Exception('Failed to register: ${errorBody['error'] ?? response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('${getBaseApiUrl()}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception('Failed to login: ${errorBody['error'] ?? response.body}');
    }
  }
}

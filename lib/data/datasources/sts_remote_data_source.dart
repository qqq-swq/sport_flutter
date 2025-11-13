import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_flutter/data/models/sts_credentials_model.dart';
import 'package:sport_flutter/data/datasources/auth_remote_data_source.dart';

abstract class StsRemoteDataSource {
  Future<StsCredentialsModel> getOssCredentials();
}

class StsRemoteDataSourceImpl implements StsRemoteDataSource {
  final http.Client client;
  final String _baseUrl = AuthRemoteDataSourceImpl.getBaseApiUrl();

  StsRemoteDataSourceImpl({required this.client});

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    if (token == null) throw Exception('Authentication token not found');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<StsCredentialsModel> getOssCredentials() async {
    final headers = await _getAuthHeaders();
    final response = await client.get(
      Uri.parse('$_baseUrl/sts/oss-credentials'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // --- THE FIX IS HERE: Removed the incorrect validation ---
      // We now directly parse the flat JSON, assuming the server response is correct.
      // A more robust solution might check for the presence of a key like 'accessKeyId'.
      if (jsonResponse is Map<String, dynamic>) {
        return StsCredentialsModel.fromJson(jsonResponse);
      } else {
        throw Exception('Invalid STS response format: Expected a JSON object.');
      }
    } else {
      print('---!!! FAILED TO GET STS CREDENTIALS !!!---');
      print('Status Code: ${response.statusCode}');
      print('Raw Response Body: ${response.body}');
      throw Exception('Failed to get OSS credentials. Status: ${response.statusCode}');
    }
  }
}
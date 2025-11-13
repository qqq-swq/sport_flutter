import 'package:sport_flutter/data/datasources/auth_remote_data_source.dart';
import 'package:sport_flutter/data/models/user_model.dart';
import 'package:sport_flutter/domain/entities/user.dart';
import 'package:sport_flutter/domain/repositories/auth_repository.dart';
import 'package:sport_flutter/data/helpers/auth_helper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> sendVerificationCode(String email) async {
    await remoteDataSource.sendVerificationCode(email);
  }

  // --- CRITICAL FIX: Corrected parameter order to match BLoC/UseCase ---
  @override
  Future<void> register(String username, String email, String password, String code) async {
    await remoteDataSource.register(username, email, password, code);
  }

  // --- CRITICAL FIX: Changed type to `dynamic` and added casting ---
  @override
  Future<User> login(String email, String password) async {
    // 1. Expect a dynamic type from the data source to be flexible
    final dynamic loginData = await remoteDataSource.login(email, password);

    // Ensure the data is a Map before proceeding
    if (loginData is! Map<String, dynamic>) {
      throw Exception('Login data is not in the expected format.');
    }

    // 2. Extract the token from the response
    final token = loginData['token'] as String?;

    // 3. If a token exists, save it using the helper
    if (token != null) {
      await AuthHelper.saveToken(token);
    } else {
      throw Exception('Authentication successful, but no token was provided.');
    }

    // 4. Parse the user data from the 'user' key in the response
    final userJson = loginData['user'] as Map<String, dynamic>?;
    if (userJson != null) {
      return UserModel.fromJson(userJson);
    } else {
      throw Exception('Authentication successful, but no user data was provided.');
    }
  }

  // This method might not be in your AuthRepository interface. 
  // If it's not, you can remove the @override annotation or the method itself.
  @override
  Future<void> logout() async {
    await AuthHelper.clearToken();
  }
}

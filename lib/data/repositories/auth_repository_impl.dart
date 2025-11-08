import 'package:sport_flutter/data/datasources/auth_remote_data_source.dart';
import 'package:sport_flutter/domain/entities/user.dart';
import 'package:sport_flutter/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> sendVerificationCode(String email) async {
    try {
      await remoteDataSource.sendVerificationCode(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> register(String username, String password, String email, String code) async {
    try {
      await remoteDataSource.register(username, password, email, code);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> login(String username, String password) async {
    try {
      final userModel = await remoteDataSource.login(username, password);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    // Implement logout logic, e.g., clearing stored token
  }
}

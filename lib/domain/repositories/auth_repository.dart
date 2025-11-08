import 'package:sport_flutter/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  // Register now requires a verification code
  Future<void> register(String username, String password, String email, String code);
  Future<void> logout();
  // New method to send the verification code
  Future<void> sendVerificationCode(String email);
}

import 'package:sport_flutter/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<void> call(String username, String password, String email, String code) {
    return repository.register(username, password, email, code);
  }
}

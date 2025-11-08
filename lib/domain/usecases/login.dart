import 'package:sport_flutter/domain/entities/user.dart';
import 'package:sport_flutter/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<User> call(String username, String password) {
    return repository.login(username, password);
  }
}

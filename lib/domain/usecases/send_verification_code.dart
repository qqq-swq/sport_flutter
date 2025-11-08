import 'package:sport_flutter/domain/repositories/auth_repository.dart';

class SendVerificationCode {
  final AuthRepository repository;

  SendVerificationCode(this.repository);

  Future<void> call(String email) {
    return repository.sendVerificationCode(email);
  }
}

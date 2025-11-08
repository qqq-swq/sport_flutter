import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

// Updated RegisterEvent to include the code
class RegisterEvent extends AuthEvent {
  final String username;
  final String password;
  final String email;
  final String code;

  const RegisterEvent({required this.username, required this.password, required this.email, required this.code});

  @override
  List<Object> get props => [username, password, email, code];
}

// New event to trigger sending the code
class SendCodeEvent extends AuthEvent {
  final String email;

  const SendCodeEvent({required this.email});

  @override
  List<Object> get props => [email];
}

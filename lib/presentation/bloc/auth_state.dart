import 'package:equatable/equatable.dart';
import 'package:sport_flutter/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// General States
class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

// Authentication Status States
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

// --- New States for Registration Flow ---

// State while the verification code is being sent
class AuthCodeSending extends AuthState {}

// State when the code has been successfully sent
class AuthCodeSentSuccess extends AuthState {}

// State for when sending the code fails
class AuthCodeSendFailure extends AuthState {
  final String error;

  const AuthCodeSendFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

// State for when registration is successful
class AuthRegistrationSuccess extends AuthState {}

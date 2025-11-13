import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/data/helpers/auth_helper.dart'; 
import 'package:sport_flutter/domain/entities/user.dart';
import 'package:sport_flutter/domain/usecases/login.dart';
import 'package:sport_flutter/domain/usecases/register.dart';
import 'package:sport_flutter/domain/usecases/send_verification_code.dart';
import 'package:equatable/equatable.dart';

// #region Auth State
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthCodeSent extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated({required this.user});
  @override
  List<Object> get props => [user];
}
// New state for successful registration
class AuthRegistrationSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}
// #endregion

// #region Auth Event
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class SendCodeEvent extends AuthEvent {
  final String email;
  const SendCodeEvent(this.email);
  @override
  List<Object> get props => [email];
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String code;
  const RegisterEvent(this.username, this.email, this.password, this.code);
  @override
  List<Object> get props => [username, email, password, code];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}
// #endregion

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Register registerUseCase;
  final SendVerificationCode sendCodeUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.sendCodeUseCase,
  }) : super(AuthInitial()) {
    on<SendCodeEvent>(_onSendCode);
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
  }

  void _onSendCode(SendCodeEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await sendCodeUseCase(event.email);
      emit(AuthCodeSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // --- CRITICAL FIX: Handle void return type for registration ---
  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // registerUseCase does not return a user or token, it just completes.
      await registerUseCase(event.username, event.email, event.password, event.code);
      // Emit a new state to signify success.
      emit(AuthRegistrationSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // --- CRITICAL FIX: Handle User return type for login ---
  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // loginUseCase returns a User object directly.
      // We assume the token is saved to SharedPreferences inside the repository.
      final user = await loginUseCase(event.email, event.password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

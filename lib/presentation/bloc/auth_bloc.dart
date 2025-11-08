import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/domain/usecases/login.dart';
import 'package:sport_flutter/domain/usecases/register.dart';
import 'package:sport_flutter/domain/usecases/send_verification_code.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Register registerUseCase;
  final SendVerificationCode sendCodeUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.sendCodeUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<SendCodeEvent>(_onSendCode);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.username, event.password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  void _onSendCode(SendCodeEvent event, Emitter<AuthState> emit) async {
    emit(AuthCodeSending());
    try {
      await sendCodeUseCase(event.email);
      emit(AuthCodeSentSuccess());
    } catch (e) {
      emit(AuthCodeSendFailure(error: e.toString()));
    }
  }

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await registerUseCase(event.username, event.password, event.email, event.code);
      emit(AuthRegistrationSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}

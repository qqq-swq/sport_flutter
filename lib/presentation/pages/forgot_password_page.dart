import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/l10n/app_localizations.dart';
import 'package:sport_flutter/presentation/bloc/auth_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCodeSent = false;
  Timer? _timer;
  int _countdown = 60;

  @override
  void dispose() {
    _timer?.cancel();
    _usernameController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    if (!mounted) return;
    setState(() {
      _isCodeSent = true;
      _countdown = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        _timer?.cancel();
        setState(() {}); // Rebuild to enable the resend button.
      }
    });
  }

  void _sendForgotPasswordCode() {
    if (_formKey.currentState?.validate() == true) {
      final authBloc = context.read<AuthBloc>();
      authBloc.add(ForgotPasswordSendCodeEvent(
        _usernameController.text,
        _emailController.text,
      ));
    }
  }

  void _resetForgottenPassword() {
    if (_formKey.currentState?.validate() == true) {
      context.read<AuthBloc>().add(ForgotPasswordResetEvent(
            _usernameController.text,
            _emailController.text,
            _codeController.text,
            _passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordCodeSent) {
          _startCountdown();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.codeSent)));
        } else if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.passwordResetSuccessLogin), backgroundColor: Colors.green));
          Navigator.of(context).pop(true);
        } else if (state is AuthError) {
          if (state.errorType == 'ForgotPasswordSendCodeError') {
            _timer?.cancel();
            setState(() => _isCodeSent = false);
          }
          final message = state.message == 'usernameAndEmailMismatch' ? l10n.usernameAndEmailMismatch : state.message;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: colorScheme.error,
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.resetPassword)),
        body: SafeArea(
          child: LayoutBuilder(builder: (context, viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.resetYourPassword,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.resetPasswordInstruction,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _usernameController,
                          decoration: inputDecoration.copyWith(
                            labelText: l10n.username,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) => value!.isEmpty ? l10n.enterUsername : null,
                          enabled: !_isCodeSent,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: inputDecoration.copyWith(
                            labelText: l10n.email,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          validator: (value) => (value == null || !value.contains('@')) ? l10n.enterValidEmail : null,
                          enabled: !_isCodeSent,
                        ),
                        const SizedBox(height: 32),
                        if (!_isCodeSent) ...[
                          ElevatedButton(
                            onPressed: _sendForgotPasswordCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthLoading && state.loadingType == 'ForgotPasswordSendCode') {
                                  return const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white));
                                }
                                return Text(l10n.sendVerificationCode.toUpperCase());
                              },
                            ),
                          ),
                        ] else ...[
                          TextFormField(
                            controller: _codeController,
                            decoration: inputDecoration.copyWith(
                              labelText: l10n.verificationCode,
                              prefixIcon: const Icon(Icons.verified_user_outlined),
                              suffixIcon: TextButton(
                                onPressed: _countdown > 0 ? null : _sendForgotPasswordCode,
                                child: Text(_countdown > 0 ? '$_countdown s' : l10n.sendVerificationCode),
                              ),
                            ),
                            validator: (value) => value!.isEmpty ? l10n.enterVerificationCode : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: inputDecoration.copyWith(
                                labelText: l10n.newPassword, prefixIcon: const Icon(Icons.lock_outline)),
                            obscureText: true,
                            validator: (value) => (value == null || value.length < 6) ? l10n.passwordTooShort : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: inputDecoration.copyWith(
                                labelText: l10n.confirmNewPassword, prefixIcon: const Icon(Icons.lock_outline)),
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value != _passwordController.text ? l10n.passwordsDoNotMatch : null,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _resetForgottenPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthLoading && state.loadingType == 'ForgotPasswordReset') {
                                  return const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white));
                                }
                                return Text(l10n.confirmReset.toUpperCase());
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

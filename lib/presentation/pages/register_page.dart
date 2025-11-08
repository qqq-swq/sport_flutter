import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/presentation/bloc/auth_bloc.dart';
import 'package:sport_flutter/presentation/bloc/auth_event.dart';
import 'package:sport_flutter/presentation/bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  bool _codeSent = false; // Controls the visibility of the code input field

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeSentSuccess) {
            _showSnackBar('Verification code sent to your email!');
            setState(() {
              _codeSent = true; // Show the code input field
            });
          } else if (state is AuthCodeSendFailure) {
            _showSnackBar('Error: ${state.error}');
          } else if (state is AuthRegistrationSuccess) {
            _showSnackBar('Registration successful! Please log in.');
            Navigator.of(context).pop();
          } else if (state is AuthFailure) {
            _showSnackBar('Registration Failed: ${state.error}');
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading || state is AuthCodeSending) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    enabled: !_codeSent, // Disable after sending code
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    enabled: !_codeSent, // Disable after sending code
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  if (_codeSent)
                    TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(labelText: 'Verification Code'),
                      keyboardType: TextInputType.number,
                    ),
                  const SizedBox(height: 24),
                  if (!_codeSent)
                    ElevatedButton(
                      onPressed: () {
                        final email = _emailController.text.trim();
                        if (email.isEmpty || !email.contains('@')) {
                          _showSnackBar('Please enter a valid email.');
                          return;
                        }
                        context.read<AuthBloc>().add(SendCodeEvent(email: email));
                      },
                      child: const Text('Send Verification Code'),
                    ),
                  if (_codeSent)
                    ElevatedButton(
                      onPressed: () {
                        final username = _usernameController.text.trim();
                        final password = _passwordController.text.trim();
                        final email = _emailController.text.trim();
                        final code = _codeController.text.trim();

                        if (username.isEmpty || password.isEmpty || email.isEmpty || code.isEmpty) {
                          _showSnackBar('Please fill in all fields.');
                          return;
                        }
                        context.read<AuthBloc>().add(RegisterEvent(
                              username: username,
                              password: password,
                              email: email,
                              code: code,
                            ));
                      },
                      child: const Text('Register'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

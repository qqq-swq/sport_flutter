import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/presentation/bloc/auth_bloc.dart';
import 'package:sport_flutter/presentation/bloc/auth_event.dart';
import 'package:sport_flutter/presentation/bloc/auth_state.dart';
import 'package:sport_flutter/presentation/pages/home_page.dart';
import 'package:sport_flutter/presentation/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to the home page on successful login
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (state is AuthFailure) {
            // Show an error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Failed: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final username = _usernameController.text;
                    final password = _passwordController.text;
                    context.read<AuthBloc>().add(LoginEvent(username: username, password: password));
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to the registration page
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterPage()));
                  },
                  child: const Text('Don\'t have an account? Register'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

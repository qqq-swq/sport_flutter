import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_flutter/data/datasources/auth_remote_data_source.dart';
import 'package:sport_flutter/data/repositories/auth_repository_impl.dart';
import 'package:sport_flutter/domain/usecases/login.dart';
import 'package:sport_flutter/domain/usecases/register.dart';
import 'package:sport_flutter/domain/usecases/send_verification_code.dart';
import 'package:sport_flutter/presentation/bloc/auth_bloc.dart';
import 'package:sport_flutter/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Dependency Injection ---
  final sharedPreferences = await SharedPreferences.getInstance();
  final client = http.Client();

  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    client: client,
    sharedPreferences: sharedPreferences,
  );

  final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);

  // Use cases
  final loginUseCase = Login(authRepository);
  final registerUseCase = Register(authRepository);
  final sendCodeUseCase = SendVerificationCode(authRepository);

  runApp(
    MyApp(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      sendCodeUseCase: sendCodeUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Login loginUseCase;
  final Register registerUseCase;
  final SendVerificationCode sendCodeUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.sendCodeUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        loginUseCase: loginUseCase,
        registerUseCase: registerUseCase,
        sendCodeUseCase: sendCodeUseCase,
      ),
      child: MaterialApp(
        title: 'Video App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
      ),
    );
  }
}

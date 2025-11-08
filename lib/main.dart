import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_flutter/data/datasources/auth_remote_data_source.dart';
import 'package:sport_flutter/data/datasources/video_remote_data_source.dart';
import 'package:sport_flutter/data/repositories/auth_repository_impl.dart';
import 'package:sport_flutter/data/repositories/video_repository_impl.dart';
import 'package:sport_flutter/domain/usecases/get_videos.dart';
import 'package:sport_flutter/domain/usecases/login.dart';
import 'package:sport_flutter/domain/usecases/register.dart';
import 'package:sport_flutter/domain/usecases/send_verification_code.dart';
import 'package:sport_flutter/presentation/bloc/auth_bloc.dart';
import 'package:sport_flutter/presentation/pages/home_page.dart';
import 'package:sport_flutter/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Dependency Injection ---
  final client = http.Client();

  // Auth Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: client, sharedPreferences: sharedPreferences);
  final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
  final loginUseCase = Login(authRepository);
  final registerUseCase = Register(authRepository);
  final sendCodeUseCase = SendVerificationCode(authRepository);

  // Video Dependencies
  final videoRemoteDataSource = VideoRemoteDataSourceImpl(client: client);
  final videoRepository = VideoRepositoryImpl(remoteDataSource: videoRemoteDataSource);
  final getVideosUseCase = GetVideos(videoRepository);

  runApp(
    MyApp(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      sendCodeUseCase: sendCodeUseCase,
      getVideosUseCase: getVideosUseCase, // Pass the use case down
    ),
  );
}

class MyApp extends StatelessWidget {
  final Login loginUseCase;
  final Register registerUseCase;
  final SendVerificationCode sendCodeUseCase;
  final GetVideos getVideosUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.sendCodeUseCase,
    required this.getVideosUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Provide use cases to the widget tree so HomePage can access it.
        RepositoryProvider.value(value: getVideosUseCase),
      ],
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          loginUseCase: loginUseCase,
          registerUseCase: registerUseCase,
          sendCodeUseCase: sendCodeUseCase,
        ),
        child: MaterialApp(
          title: 'Video App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginPage(),
        ),
      ),
    );
  }
}

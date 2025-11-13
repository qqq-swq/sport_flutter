import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart'; 

// Core
import 'package:sport_flutter/presentation/pages/login_page.dart';

// DI - DataSources
import 'package:sport_flutter/data/datasources/auth_remote_data_source.dart';
import 'package:sport_flutter/data/datasources/video_remote_data_source.dart';
import 'package:sport_flutter/data/datasources/community_remote_data_source.dart';
import 'package:sport_flutter/data/datasources/sts_remote_data_source.dart';

// DI - Repositories
import 'package:sport_flutter/data/repositories/auth_repository_impl.dart';
import 'package:sport_flutter/data/repositories/video_repository_impl.dart';
import 'package:sport_flutter/data/repositories/community_post_repository_impl.dart';

// DI - UseCases
import 'package:sport_flutter/domain/usecases/login.dart';
import 'package:sport_flutter/domain/usecases/register.dart';
import 'package:sport_flutter/domain/usecases/send_verification_code.dart';
import 'package:sport_flutter/domain/usecases/get_videos.dart';
import 'package:sport_flutter/domain/usecases/get_community_posts.dart';
import 'package:sport_flutter/domain/usecases/create_community_post.dart';

// DI - Services
import 'package:sport_flutter/services/oss_upload_service.dart';

// DI - BLoCs
import 'package:sport_flutter/presentation/bloc/auth_bloc.dart';

// Cache
import 'package:sport_flutter/data/cache/video_cache_manager.dart';

// 全局路由观察者
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = http.Client();
  final dioClient = Dio();

  // Auth Dependencies
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);
  final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
  final loginUseCase = Login(authRepository);
  final registerUseCase = Register(authRepository);
  final sendCodeUseCase = SendVerificationCode(authRepository);

  // Video Dependencies
  final videoRemoteDataSource = VideoRemoteDataSourceImpl(client: httpClient);
  final videoRepository = VideoRepositoryImpl(remoteDataSource: videoRemoteDataSource);
  final getVideosUseCase = GetVideos(videoRepository);

  // STS and OSS Dependencies
  final stsRemoteDataSource = StsRemoteDataSourceImpl(client: httpClient);
  final ossUploadService = OssUploadService(stsDataSource: stsRemoteDataSource, dio: dioClient);

  // Community Dependencies
  final communityRemoteDataSource = CommunityRemoteDataSourceImpl(client: httpClient);
  final communityPostRepository = CommunityPostRepositoryImpl(remoteDataSource: communityRemoteDataSource);
  final getCommunityPostsUseCase = GetCommunityPosts(communityPostRepository);
  final createCommunityPostUseCase = CreateCommunityPost(communityPostRepository);

  // Cache
  final videoCacheManager = CustomVideoCacheManager().instance;

  runApp(
    MyApp(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      sendCodeUseCase: sendCodeUseCase,
      getVideosUseCase: getVideosUseCase,
      getCommunityPostsUseCase: getCommunityPostsUseCase,
      createCommunityPostUseCase: createCommunityPostUseCase,
      ossUploadService: ossUploadService, 
      videoCacheManager: videoCacheManager,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Login loginUseCase;
  final Register registerUseCase;
  final SendVerificationCode sendCodeUseCase;
  final GetVideos getVideosUseCase;
  final GetCommunityPosts getCommunityPostsUseCase;
  final CreateCommunityPost createCommunityPostUseCase;
  final OssUploadService ossUploadService; 
  final CacheManager videoCacheManager;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.sendCodeUseCase,
    required this.getVideosUseCase,
    required this.getCommunityPostsUseCase,
    required this.createCommunityPostUseCase,
    required this.ossUploadService, 
    required this.videoCacheManager,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: getVideosUseCase),
        RepositoryProvider.value(value: getCommunityPostsUseCase),
        RepositoryProvider.value(value: createCommunityPostUseCase),
        RepositoryProvider.value(value: ossUploadService), 
        RepositoryProvider.value(value: videoCacheManager),
      ],
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          loginUseCase: loginUseCase,
          registerUseCase: registerUseCase,
          sendCodeUseCase: sendCodeUseCase,
        ),
        child: MaterialApp(
          title: '体育应用',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          navigatorObservers: [routeObserver],
          home: LoginPage(),
        ),
      ),
    );
  }
}

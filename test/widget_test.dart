// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sport_flutter/domain/entities/user.dart';
import 'package:sport_flutter/domain/repositories/auth_repository.dart';
import 'package:sport_flutter/domain/usecases/login.dart';
import 'package:sport_flutter/domain/usecases/register.dart';

import 'package:sport_flutter/main.dart';

// 因为 `MyApp` widget 现在需要依赖项，我们需要在测试中提供
// 模拟 (mock) 实现。
class MockAuthRepository implements AuthRepository {
  @override
  Future<User> login(String username, String password) async {
    // 为了测试，我们可以返回一个虚拟用户。
    if (username == 'test' && password == 'password') {
      return const User(id: '1', username: 'test', email: 'test@example.com');
    }
    throw Exception('Failed to login');
  }

  @override
  Future<void> register(String username, String password, String email) async {
    // 模拟一个成功的注册。
    return;
  }

  @override
  Future<void> logout() async {
    // 无操作。
    return;
  }
}

void main() {
  testWidgets('Login page smoke test', (WidgetTester tester) async {
    // 1. 创建我们的模拟依赖项的实例。
    final mockAuthRepository = MockAuthRepository();
    final loginUseCase = Login(mockAuthRepository);
    final registerUseCase = Register(mockAuthRepository);

    // 2. 构建我们的应用并触发一个帧。
    // 我们将模拟的 use cases 传递给 MyApp widget。
    await tester.pumpWidget(MyApp(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
    ));

    // 3. 验证初始页面是 LoginPage。
    // AppBar 的标题是 'Login'。
    expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);

    // 应该有两个用于用户名和密码的 TextField。
    expect(find.byType(TextField), findsNWidgets(2));

    // 应该有一个登录按钮。
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    // 旧测试中与计数器相关的 widget 不应该存在。
    expect(find.text('0'), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
  });
}

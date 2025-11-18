
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/presentation/bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isAgreementChecked = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterEvent(
              _usernameController.text,
              _emailController.text,
              _passwordController.text,
              _codeController.text,
            ),
          );
    }
  }

  void _sendVerificationCode() {
    // Basic email validation before sending code
    if (_emailController.text.isNotEmpty && _emailController.text.contains('@')) {
      context.read<AuthBloc>().add(SendCodeEvent(_emailController.text));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的邮箱地址')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('注册')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
          }
          if (state is AuthRegistrationSuccess) {
            Navigator.of(context).pop(); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('注册成功! 请登录'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop(); // Go back to login page
          }
          if (state is AuthError) {
            Navigator.of(context).pop(); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
          if (state is AuthCodeSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('验证码已发送'), backgroundColor: Colors.blue),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: '用户名'),
                    validator: (value) => value!.isEmpty ? '请输入用户名' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: '邮箱'),
                    validator: (value) => value!.isEmpty || !value.contains('@') ? '请输入有效的邮箱地址' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '密码',
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) => value!.length < 6 ? '密码长度不能少于6位' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          decoration: const InputDecoration(labelText: '验证码'),
                          validator: (value) => value!.isEmpty ? '请输入验证码' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _sendVerificationCode,
                        child: const Text('发送验证码'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isAgreementChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isAgreementChecked = value ?? false;
                          });
                        },
                      ),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                            children: <TextSpan>[
                              const TextSpan(text: '我已阅读并同意 '),
                              TextSpan(
                                text: '《App使用声明》',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('App使用声明'),
                                          content: const SingleChildScrollView(
                                            child: Text('''本使用声明旨在明确你使用本 App 时的权利与义务，保护双方合法权益。请你在下载、安装、注册或使用本 App 前，仔细阅读并充分理解本声明全部内容，一旦你开始使用本 App，即视为你已接受本声明的所有条款。若你不同意本声明，请勿使用本 App。\n一、使用前提与账号规范\n你需具备完全民事行为能力，若为未成年人，需在法定监护人同意下使用本 App，且监护人应承担相应责任。\n注册账号时，你应提供真实、准确、完整的信息（如手机号、邮箱等），并及时更新，确保信息有效性。\n你应对账号密码及相关身份验证信息保密，独自承担账号使用所产生的一切责任。若发现账号被盗用、泄露等情况，需立即联系客服处理。\n禁止出租、出借、转让或售卖账号，否则本 App 有权暂停或注销账号，且你需承担由此引发的法律责任。\n二、App 使用范围与限制\n本 App 仅为你提供【核心功能描述，如：信息查询、社交互动、线上交易等】相关服务，你应合规使用这些功能，不得用于非法目的。\n禁止利用本 App 从事以下行为：\n违反法律法规、公序良俗或损害国家、集体、他人合法权益的行为；\n传播淫穢、暴力、恐怖、虛假信息等違法或不良內容；\n惡意攻擊、侵入本 App 伺服器，篡改數據，或利用技術手段干擾 App 正常運行；\n未經允許採集、爬取本 App 內數據、內容或其他用戶信息；\n其他侵犯本 App 知識產權或違反本聲明的行為。\n你需遵守本 App 發布的各類規則、公告，若有違反，本 App 有權采取警告、限制功能、暫停或註銷賬號等措施。\n三、知識產權聲明\n本 App 的軟體著作權、商標權、logo、界面設計、功能架構及所有內容（包括但不限於文字、圖片、音頻、視頻等）均歸【開發者 / 運營方名稱】所有，受法律法規保護。\n未經授權，你不得復制、修改、傳播、分發、出租、許可他人使用本 App 的任何知識產權相關內容，否則需承擔侵權責任。\n你在本 App 上傳的原創內容（如頭像、動態、評論等），知識產權歸你所有，但你授予本 App 免費、非獨占、可轉授權的使用權，用於 App 運營、推廣等合法用途（如展示、存儲、傳播等）。若你希望撤回授權，可聯繫客服刪除相關內容，但已合法傳播的部分除外。\n四、免責聲明\n本 App 盡力保障服務的穩定性和安全性，但不保證無中斷、無錯誤或無病毒，因技術故障、網絡問題、第三方攻擊等不可抗力或不可歸責於本 App 的原因導致你遭受損失，本 App 不承擔賠償責任。\n你應對自身使用本 App 的行為及上傳內容負責，因你的行為或內容引發的糾紛、損失，由你自行承担，本 App 不承担連帶責任。\n本 App 對第三方提供的鏈接、服務或內容不承擔責任，你通過本 App 訪問第三方服務時，需遵守第三方的相關規則。\n因法律法規調整、監管要求或業務優化，本 App 可調整服務內容或暫停、終止部分服務，若因此給你造成合理損失，僅承擔有限補償責任（若有）。\n五、隱私保護\n本 App 重視你的隱私保護，將按照《隱私政策》收集、使用、存儲和保護你的個人信息。\n请你仔细阅读《隐私政策》，了解信息处理的具体规则，使用本 App 即视为你同意《隐私政策》的全部内容。\n六、聲明的修改與生效\n本 App 可根據業務發展、法律法規變化等情況修改本聲明，修改後的聲明將在 App 內公示，公示後生效。若你繼續使用本 App，視為接受修改後的聲明；若不同意，可停止使用。\n本聲明自你首次使用本 App 之日起生效，有效期至你停止使用本 App 或賬號被註銷之日止。\n七、其他條款\n本聲明的簽訂、履行、解釋及爭議解決均適用中華人民共和國法律。\n若你与本 App 就本声明产生争议，应优先协商解决；协商不成的，可向【开发者 / 运营方所在地】有管辖权的人民法院提起诉讼。'''),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text('关闭'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isAgreementChecked ? _register : null,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('注册'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

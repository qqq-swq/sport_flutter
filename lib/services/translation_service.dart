import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _appId = '20230522001685444'; // Replace with your App ID
  static const String _appSecret = 'qcEQl156_3sdFvOXTLup'; // Replace with your App Secret
  static const String _baseUrl = 'https://fanyi-api.baidu.com/api/trans/vip/translate';

  // In-memory cache for translations
  final Map<String, String> _translationCache = {};

  // Maps standard ISO language codes to Baidu-specific codes
  static final Map<String, String> _languageCodeMap = {
    'en': 'en',   // English
    'zh': 'zh',   // Chinese
    'fr': 'fra',  // French
    'de': 'de',   // German
    'ru': 'ru',   // Russian
    'es': 'spa',  // Spanish
    'ja': 'jp',   // Japanese
    'ko': 'kor',  // Korean
  };

  Future<String> translate(String query, String toLanguage) async {
    // If the target language is Chinese, no translation is needed.
    if (toLanguage == 'zh') {
      return query;
    }

    // Check cache first
    final cacheKey = '$toLanguage:$query';
    if (_translationCache.containsKey(cacheKey)) {
      return _translationCache[cacheKey]!;
    }

    if (_appId == 'YOUR_BAIDU_APP_ID' || _appSecret == 'YOUR_BAIDU_APP_SECRET') {
      print('Baidu Translation API Error: App ID or App Secret is not set.');
      return '[请设置API密钥] $query';
    }

    // Normalize the language code and convert to Baidu-specific code
    final lang = toLanguage.split('_').first.split('-').first.toLowerCase();
    final baiduLanguageCode = _languageCodeMap[lang] ?? lang;

    final salt = DateTime.now().millisecondsSinceEpoch.toString();
    final sign = _generateSign(query, salt);
    final url = '$_baseUrl?q=${Uri.encodeComponent(query)}&from=auto&to=$baiduLanguageCode&appid=$_appId&salt=$salt&sign=$sign';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['trans_result'] != null && decoded['trans_result'].isNotEmpty) {
          final translatedText = decoded['trans_result'][0]['dst'];
          // Store result in cache
          _translationCache[cacheKey] = translatedText;
          return translatedText;
        } else if (decoded['error_code'] != null) {
          final errorCode = decoded['error_code'];
          final errorMsg = decoded['error_msg'];
          // Avoid printing error during tests or known scenarios
          if (errorCode != '58001') { // Suppress INVALID_TO_PARAM for cleaner logs if it's a known issue being handled
             print('Baidu Translation API Error: $errorMsg (Code: $errorCode)');
          }
          throw Exception('Baidu API Error: $errorMsg (code: $errorCode)');
        }
      }
      throw Exception('HTTP Error ${response.statusCode}');
    } catch (e) {
      print('Failed to translate: $e');
      throw Exception('Translation failed: $e');
    }
  }

  String _generateSign(String query, String salt) {
    final str = '$_appId$query$salt$_appSecret';
    return md5.convert(utf8.encode(str)).toString();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/services/translation_service.dart';

class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const TranslatedText({super.key, required this.text, required this.style});

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String _translatedText = '';
  bool _didTranslate = false;

  @override
  void initState() {
    super.initState();
    // Initially, display the original text.
    _translatedText = widget.text;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The key on the widget ensures this State object is new when the locale or text changes.
    // We only need to translate once when the dependencies are first available.
    if (!_didTranslate) {
      _didTranslate = true;
      _translateText();
    }
  }

  Future<void> _translateText() async {
    // No need to translate if the widget is no longer in the tree.
    if (!mounted) return;

    final languageCode = Localizations.localeOf(context).languageCode;
    
    // No need to translate if the target language is Chinese (or the base language of the app).
    if (languageCode == 'zh') {
        return;
    }

    try {
      final translationService = context.read<TranslationService>();
      final result = await translationService.translate(widget.text, languageCode);
      if (mounted) {
        setState(() {
          _translatedText = result;
        });
      }
    } catch (e) {
      // If translation fails, we just show the original text.
      // The error is already logged by the service.
      if (mounted) {
          setState(() {
              _translatedText = widget.text;
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _translatedText,
      style: widget.style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

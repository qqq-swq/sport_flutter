import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class LocaleEvent extends Equatable {
  const LocaleEvent();
  @override
  List<Object> get props => [];
}

class LoadLocale extends LocaleEvent {}

class ChangeLocale extends LocaleEvent {
  final Locale locale;
  const ChangeLocale(this.locale);
  @override
  List<Object> get props => [locale];
}

// States
class LocaleState extends Equatable {
  final Locale locale;
  const LocaleState(this.locale);

  @override
  List<Object> get props => [locale];
}

// BLoC
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(Locale('zh'))) { // Default to Chinese
    on<LoadLocale>(_onLoadLocale);
    on<ChangeLocale>(_onChangeLocale);
  }

  Future<void> _onLoadLocale(LoadLocale event, Emitter<LocaleState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');

    if (languageCode != null) {
      emit(LocaleState(Locale(languageCode)));
    }
  }

  Future<void> _onChangeLocale(ChangeLocale event, Emitter<LocaleState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', event.locale.languageCode);
    await prefs.remove('countryCode'); // Clean up old preference
    emit(LocaleState(event.locale));
  }
}

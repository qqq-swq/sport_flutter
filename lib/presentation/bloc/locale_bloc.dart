import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class LocaleEvent extends Equatable {
  const LocaleEvent();
  @override
  List<Object> get props => [];
}

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
    on<ChangeLocale>((event, emit) {
      emit(LocaleState(event.locale));
    });
  }
}

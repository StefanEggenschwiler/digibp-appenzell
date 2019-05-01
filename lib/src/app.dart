import 'dart:ui';

import 'package:flutter/material.dart';

class Application {

  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  static final List<String> _supportedLanguages = [
    'Deutsch',
    'English'
  ];

  static final List<String> _supportedLanguagesCodes = [
    'de',
    'en',
  ];

  final Map<String, String> languagesMap = new Map.fromIterables(_supportedLanguages, _supportedLanguagesCodes);

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      _supportedLanguagesCodes.map<Locale>((language) => Locale(language, ''));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale);
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';

class LocaleControllerNotifier extends StateNotifier<Locale> {
  LocaleControllerNotifier() : super(const Locale('vi')) {
    fetchLocale();
  }

  Future fetchLocale() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('language_code')) {
      state = Locale(prefs.getString('language_code')!);
    } else {
      String deviceLanguageCode = Platform.localeName.split('_').first;

      if (L10n.all.contains(Locale(deviceLanguageCode))) {
        state = Locale(deviceLanguageCode);
        await prefs.setString('language_code', deviceLanguageCode);
      } else {
        state = const Locale('vi');
        await prefs.setString('language_code', 'vi');
      }
    }
  }

  Future changeLocale(Locale locale) async {
    if (state == locale) return;

    state = locale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }
}

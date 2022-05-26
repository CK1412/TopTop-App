import 'package:flutter/material.dart';

class L10n {
  static const all = [
    Locale('vi'),
    Locale('en'),
  ];

  static String getLanguage({required String code}) {
    switch (code) {
      case 'vi':
        return 'Tiếng Việt (vi)';
      case 'en':
        return 'English (en)';
      default:
        return '';
    }
  }
}

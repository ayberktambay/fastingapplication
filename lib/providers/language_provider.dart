import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('tr', 'TR');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey) ?? 'tr';
    _currentLocale = Locale(savedLanguage);
    notifyListeners();
  }

  void setLanguage(String languageCode) {
    if (languageCode == 'tr') {
      _currentLocale = const Locale('tr', 'TR');
    } else if (languageCode == 'en') {
      _currentLocale = const Locale('en', 'US');
    }
    notifyListeners();
  }
} 
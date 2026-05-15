import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/controllers/theme_controller.dart';
import 'package:customer/utils/preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _isDarkMode = Preferences.getBoolean(Preferences.themKey);
  }

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _setDarkMode(!_isDarkMode);
  }

  void setDarkMode(bool value) {
    _setDarkMode(value);
  }

  void _setDarkMode(bool value) {
    _isDarkMode = value;
    Preferences.setBoolean(Preferences.themKey, value);

    if (Get.isRegistered<ThemeController>()) {
      Get.find<ThemeController>().isDark.value = value;
    }

    notifyListeners();
  }
}

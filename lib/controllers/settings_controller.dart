import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_keys.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var currentLocale = Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Theme
    String? theme = prefs.getString(AppKeys.themeMode);
    if (theme == 'dark') {
      isDarkMode.value = true;
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      isDarkMode.value = false;
      Get.changeThemeMode(ThemeMode.light);
    }

    // Language
    String? lang = prefs.getString(AppKeys.language);
    if (lang == 'ar') {
      currentLocale.value = Locale('ar', 'SA');
    } else {
      currentLocale.value = Locale('en', 'US');
    }
    Get.updateLocale(currentLocale.value);
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppKeys.themeMode, isDarkMode.value ? 'dark' : 'light');
  }

  Future<void> changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    if (langCode == 'ar') {
      currentLocale.value = Locale('ar', 'SA');
      await prefs.setString(AppKeys.language, 'ar');
    } else {
      currentLocale.value = Locale('en', 'US');
      await prefs.setString(AppKeys.language, 'en');
    }
    Get.updateLocale(currentLocale.value);
  }
}

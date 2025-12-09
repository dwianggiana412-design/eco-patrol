// lib/helpers/session_manager.dart

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // Instance SharedPreferences
  static late SharedPreferences _prefs;

  // Key untuk status login
  static const String _keyIsLoggedIn = 'isLoggedIn';

  // Key untuk contoh pengaturan (misal, tema gelap)
  static const String _keyDarkMode = 'isDarkMode';

  // --- INISIALISASI ---
  // Harus dipanggil di main() sebelum runApp
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- MANAJEMEN SESI LOGIN ---
  
  // Mendapatkan status login
  static bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;

  // Menyimpan status login
  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }

  // --- MANAJEMEN SETTINGS ---

  // Mendapatkan status Dark Mode
  static bool get isDarkMode => _prefs.getBool(_keyDarkMode) ?? false;

  // Menyimpan status Dark Mode
  static Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyDarkMode, value);
  }
}
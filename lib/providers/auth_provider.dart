import 'package:flutter_riverpod/legacy.dart';
import '../helpers/session_manager.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false) {
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    state = SessionManager.isLoggedIn;
  }

  Future<void> register(String username, String password) async {
    if (username.length < 3) {
      throw Exception('Username minimal 3 karakter');
    }
    if (password.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }
  }

  Future<void> login(String username, String password) async {
    if (username == 'user' && password == '123') {
      await SessionManager.setLoggedIn(true);
      state = true; 
    } else {
      throw Exception('Username atau Password salah');
    }
  }

  Future<void> logout() async {
    await SessionManager.setLoggedIn(false);
    state = false;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});
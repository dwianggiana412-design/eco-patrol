// lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../helpers/session_manager.dart';

// 1. Definisikan State Class
// State: boolean, true jika sudah login
class AuthState {
  final bool isLoggedIn;

  AuthState({required this.isLoggedIn});
}

// 2. State Notifier (Logika Bisnis)
class AuthNotifier extends StateNotifier<AuthState> {
  // Constructor: Inisialisasi state awal dari SessionManager
  AuthNotifier() : super(AuthState(isLoggedIn: SessionManager.isLoggedIn));

  // --- LOGIKA LOGIN ---
  Future<void> login(String username, String password) async {
    // Implementasi otentikasi nyata (API call atau validasi sederhana)
    // Untuk studi kasus ini, kita lakukan validasi sederhana.
    
    // Simulasikan berhasil login
    if (username == 'user' && password == '123') {
      await SessionManager.setLoggedIn(true);
      
      // Update state ke 'logged in'
      state = AuthState(isLoggedIn: true); 
      
      print('LOGIN BERHASIL: Status diperbarui di Riverpod.');
    } else {
      // Simulasikan gagal login
      throw Exception('Username atau Password salah');
    }
  }

  // --- LOGIKA LOGOUT ---
  Future<void> logout() async {
    await SessionManager.setLoggedIn(false);
    
    // Update state ke 'logged out'
    state = AuthState(isLoggedIn: false);

    print('LOGOUT BERHASIL: Status diperbarui di Riverpod.');
  }
}

// 3. Provider Global
// Ini adalah objek yang akan digunakan oleh widget untuk "mendengarkan" state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
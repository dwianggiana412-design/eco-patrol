import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../helpers/session_manager.dart';

// Kelas State: Menampung status otentikasi.
class AuthState {
  final bool isLoggedIn;

  AuthState({required this.isLoggedIn});
}

// State Notifier: Mengandung semua logika bisnis otentikasi.
class AuthNotifier extends StateNotifier<AuthState> {
  // Constructor: Menginisialisasi state awal dari SessionManager.
  AuthNotifier() : super(AuthState(isLoggedIn: SessionManager.isLoggedIn));

  // Fungsi Register: Melakukan simulasi pendaftaran pengguna.
  Future<void> register(String username, String password) async {
    if (username.length < 3) {
      throw Exception('Username minimal 3 karakter');
    }
    if (password.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }
    
    print('REGISTER BERHASIL untuk user: $username.');
  }

  // Fungsi Login: Melakukan otentikasi dan memperbarui state.
  Future<void> login(String username, String password) async {
    if (username == 'user' && password == '123') {
      await SessionManager.setLoggedIn(true);
      
      state = AuthState(isLoggedIn: true); 
      
      print('LOGIN BERHASIL: Status diperbarui di Riverpod.');
    } else {
      throw Exception('Username atau Password salah');
    }
  }

  // Fungsi Logout: Mengatur status keluar dan memperbarui state.
  Future<void> logout() async {
    await SessionManager.setLoggedIn(false);
    
    state = AuthState(isLoggedIn: false);

    print('LOGOUT BERHASIL: Status diperbarui di Riverpod.');
  }
}

// Provider Global: Objek yang diakses widget untuk memantau state.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
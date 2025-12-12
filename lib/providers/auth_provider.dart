import 'package:flutter_riverpod/legacy.dart';
import '../helpers/session_manager.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false) {
    _checkInitialStatus(); //memanggil metode asinkron setelah autnotivier dibuat
  }

  Future<void> _checkInitialStatus() async {
    state = SessionManager.isLoggedIn; //mengambil status login dan mengatur sebagai state
  }

  Future<void> register(String username, String password) async {
    if (username.length < 3) { //apakah username kurang dari 3 karakter
      throw Exception('Username minimal 3 karakter');
    }
    if (password.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }
  }

  Future<void> login(String username, String password) async { //login
  //memeriksa apakah kredensial cocok dg nilai hardcoded
    if (username == 'user' && password == '123') {
      await SessionManager.setLoggedIn(true);
      state = true; 
    } else {
      throw Exception('Username atau Password salah');
    }
  }

  Future<void> logout() async {
    await SessionManager.setLoggedIn(false); //membersihkan status login di penyimpanan
    state = false;
  }
}

//authprovider
final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) { //menghubungkan statenotifier dengan state yang dikelola (bool)
  return AuthNotifier(); //instruksi ke riverpood untuk mengembalikan instance baru dari authnotifier
});
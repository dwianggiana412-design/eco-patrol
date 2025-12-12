import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart'; 

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController(); //untuk mengelola teks yang dimasukkan pengguna di bidang username dan password
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage; //menyimpan eror
  bool _isLoading = false; //untuk nonaktifkan tombol dan menampilkan spiner loading

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; //hapus eror yg sebelumnya
    });
    
    final username = _usernameController.text;
    final password = _passwordController.text;

    try { //menjalankan proses login
      await ref.read(authProvider.notifier).login(username, password);
    } catch (e) { //menangkap eror
      setState(() {
        //menangani kesalahan (koneksi gagal atau kredensial salah)
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {  
      setState(() {
        _isLoading = false; //matikan load setelah proses selesai
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EcoPatrol Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'LOGIN', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              enabled: !_isLoading, //nonaktifkan input ketika loading
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null) //menampilkan eror kalau ada
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin, //nonaktifkan tombol saat loading
              child: _isLoading
                 ? const SizedBox( //menampilkan loadig spinner
                      width: 20, 
                      height: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                   )
                 : const Text('Login'), //menmapilkan teks login
            ),
            TextButton(
              onPressed: _isLoading ? null : () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('Belum punya akun? Daftar di sini!'),
            ),
          ],
        ),
      ),
    );
  }
}
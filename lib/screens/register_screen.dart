import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

//layar untuk pendaftaran pengguna baru
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage; //variable lokal yang menyimpan pesan eror

  //Memanggil fungsi register dari AuthNotifier.
  Future<void> _handleRegister() async {
    setState(() {
      _errorMessage = null;
    });
    //pengambilan data
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      //mendelegasikan tugas ke authnotifier
      await ref.read(authProvider.notifier).register(username, password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi Berhasil! Silakan Login.')),
      );
      
      Navigator.of(context).pop();

    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EcoPatrol Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Register', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 30),
            TextField( //input yang terhubung ke texteditingcontroller
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, //untuk keamanan
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton( //tombol yang menghubungkan onpressed ke fungsi handregister
              onPressed: _handleRegister,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
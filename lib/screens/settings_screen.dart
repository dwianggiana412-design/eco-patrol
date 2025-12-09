// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../helpers/session_manager.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    // Contoh untuk Toggle Dark Mode (menggunakan SessionManager)
    final isDarkMode = ref.watch(
      StateProvider((ref) => SessionManager.isDarkMode)
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // TOMBOL LOGOUT (Tugas Utama MHS 1)
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              // Panggil fungsi logout dari AuthNotifier
              await ref.read(authProvider.notifier).logout();
              // Tidak perlu navigasi karena perubahan state akan ditangani di main.dart
            },
          ),
          const Divider(),
          // Contoh Pengaturan Lain
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode.state,
            onChanged: (bool value) {
              // Simpan ke Shared Preferences
              SessionManager.setDarkMode(value);
              // Update state Riverpod
              isDarkMode.state = value;
            },
          ),
        ],
      ),
    );
  }
}
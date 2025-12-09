// lib/main.dart (VERSI AKHIR UNTUK MHS 1 - DIPERBAIKI UNTUK SQFLITE)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'helpers/session_manager.dart';
import 'helpers/db_helper.dart'; // Import DBHelper SQFlite
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart'; // Bertindak sebagai Home sementara

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  // --- 1. INISIALISASI FONDASI ---
  
  // Inisialisasi Shared Preferences (SessionManager)
  await SessionManager.init(); 

  // >>>>>> PERBAIKAN INI PENTING UNTUK SQFLITE <<<<<<
  // 1. Buat instance DBHelper
  final dbHelper = DBHelper(); 
  // 2. Panggil getter .database untuk memicu koneksi dan pembuatan tabel SQL.
  await dbHelper.database; 
  // >>>>>> AKHIR PERBAIKAN <<<<<<

  runApp(
    const ProviderScope(child: EcoPatrolApp()), 
  );
}

// Diubah menjadi ConsumerWidget untuk mendengarkan Provider
class EcoPatrolApp extends ConsumerWidget {
  const EcoPatrolApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // DENGARKAN STATE LOGIN
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'EcoPatrol App',
      theme: ThemeData(primarySwatch: Colors.green),
      // Routing kondisional berdasarkan state login
      home: authState.isLoggedIn 
          ? const SettingsScreen() // Pengguna login
          : const LoginScreen(), // Pengguna belum login
    );
  }
}
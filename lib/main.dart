import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'helpers/session_manager.dart';
import 'helpers/db_helper.dart'; 
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await SessionManager.init(); 

  final dbHelper = DBHelper(); 
  await dbHelper.database; 

  runApp(
    const ProviderScope(child: EcoPatrolApp()), 
  );
}

class EcoPatrolApp extends ConsumerWidget {
  const EcoPatrolApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'EcoPatrol App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: authState.isLoggedIn 
          ? const SettingsScreen() 
          : const LoginScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'helpers/session_manager.dart';
import 'helpers/db_helper.dart'; 
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //memastikan kesiapan flutter
  await SessionManager.init();
  final dbHelper = DBHelper(); //memanggil get database
  await dbHelper.database;
  //meluncurkan widget akar aplikasi
  runApp(
    const ProviderScope(child: EcoPatrolApp()),
  );
}

//widget utama yang menggunakan cunsomerwidget
class EcoPatrolApp extends ConsumerWidget {
  const EcoPatrolApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider); //aksi kunci menggunakan ref.watch pada authprovider

    return MaterialApp(
      title: 'EcoPatrol App',
      theme: ThemeData(primarySwatch: Colors.green),
      //penentu navigasi awal
        home: isLoggedIn
          ? const DashboardScreen()
          : const LoginScreen(),
    );
  }
}
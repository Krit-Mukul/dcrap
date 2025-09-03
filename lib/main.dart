import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dcrap/pages/home_screen.dart';
import 'package:dcrap/pages/login_page.dart';
import 'package:dcrap/providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider);

    return MaterialApp(
      title: 'Dcrap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF137B2F)),
      ),
      home: isLoggedIn ? const HomeScreen() : const LoginPage(),
    );
  }
}














/// ===============================================
/// VIP Progress Screen
/// ===============================================





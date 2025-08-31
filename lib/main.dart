import 'package:dcrap/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const DcrapApp());

class DcrapApp extends StatelessWidget {
  const DcrapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dcrap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF137B2F)),
      ),
      home: const HomeScreen(),
    );
  }
}














/// ===============================================
/// VIP Progress Screen
/// ===============================================





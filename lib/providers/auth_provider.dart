import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends StateNotifier<bool> {
  AuthController() : super(false); // false = logged out

  void login() => state = true;
  void logout() => state = false;
  void toggle() => state = !state;
}

final authProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(),
);
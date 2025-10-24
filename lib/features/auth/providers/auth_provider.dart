import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dcrap/core/services/user_cache_service.dart';

class AuthController extends StateNotifier<bool> {
  AuthController() : super(false) {
    // Check if user is already logged in
    _checkAuthState();
  }

  void _checkAuthState() {
    final user = FirebaseAuth.instance.currentUser;
    state = user != null;
  }

  void login() => state = true;

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await UserCacheService.clearUserCache();
    state = false;
  }

  void toggle() => state = !state;
}

final authProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(),
);

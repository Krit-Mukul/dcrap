import 'package:firebase_auth/firebase_auth.dart';
import 'package:dcrap/core/services/api_service.dart';
import 'package:dcrap/core/services/user_cache_service.dart';

/// Global API error handler
/// Handles token expiration and forces re-authentication
class ApiErrorHandler {
  /// Handle API errors globally
  /// Returns true if error was handled (e.g., user logged out)
  static Future<bool> handleError(dynamic error) async {
    if (error is TokenExpiredException) {
      print('🔴 Token expired - logging out user');
      await _forceLogout();
      return true;
    }

    if (error is UnauthorizedException) {
      print('🔴 Unauthorized access - logging out user');
      await _forceLogout();
      return true;
    }

    // Error not handled
    return false;
  }

  /// Force logout when authentication fails
  static Future<void> _forceLogout() async {
    try {
      // Clear local cache
      await UserCacheService.clearUserCache();

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      print('✅ User logged out due to authentication failure');
    } catch (e) {
      print('❌ Error during forced logout: $e');
    }
  }

  /// Wrap API calls with automatic error handling
  /// Usage: await ApiErrorHandler.call(() => ApiService.getAddresses());
  static Future<T> call<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (e) {
      final handled = await handleError(e);
      if (handled) {
        rethrow; // Re-throw so UI can navigate to login
      }
      rethrow;
    }
  }
}

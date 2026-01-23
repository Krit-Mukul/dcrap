/// Application configuration for production/debug modes
class AppConfig {
  // Set to false for production builds
  static const bool isDebugMode = false;

  // Enable verbose logging (only works if isDebugMode is true)
  static const bool enableVerboseLogging = false;

  // App version info
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;

  // API Configuration
  static const String apiBaseUrl = 'https://dcrap-backend.vercel.app/api';

  // Timeout configurations
  static const int apiTimeoutSeconds = 10;
  static const int maxRetryAttempts = 2;

  /// Log helper that only prints in debug mode
  static void log(String message) {
    if (isDebugMode && enableVerboseLogging) {
      // ignore: avoid_print
      print(message);
    }
  }

  /// Error log helper that always logs errors
  static void logError(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (isDebugMode) {
      // ignore: avoid_print
      print('ERROR: $message');
      if (error != null) {
        // ignore: avoid_print
        print('Error details: $error');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        print('Stack trace: $stackTrace');
      }
    }
  }
}

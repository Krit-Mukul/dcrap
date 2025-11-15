import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  // Production Vercel deployment
  static const String baseUrl = 'https://dcrap-backend.vercel.app/api';

  // Development URLs (uncomment for local development):
  // static const String baseUrl = 'http://172.16.212.24:3000/api';  // Real device on WiFi
  // static const String baseUrl = 'http://192.168.56.1:3000/api';   // Alternative IP
  // static const String baseUrl = 'http://10.0.2.2:3000/api';       // Android emulator

  /// Get Firebase ID token for authenticated requests
  static Future<String?> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Force refresh if needed (Firebase handles caching internally)
        final token = await user.getIdToken(
          false,
        ); // false = use cached if valid
        print('🔐 Firebase user: ${user.uid}');
        print('🎫 Token length: ${token?.length ?? 0}');
        return token;
      } catch (e) {
        print('❌ Token refresh failed: $e');
        // Token refresh failed - user needs to re-authenticate
        return null;
      }
    }
    print('⚠️ No Firebase user found');
    return null;
  }

  /// Get headers with authentication
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get VIP progress (auto-creates if doesn't exist)
  static Future<Map<String, dynamic>> getVipProgress() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users/vip-progress'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to get VIP progress: $e');
    }
  }

  /// Update VIP progress
  static Future<Map<String, dynamic>> updateVipProgress({
    int? totalOrders,
    double? totalEarnings,
    double? vipProgress,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/users/vip-progress'),
        headers: headers,
        body: jsonEncode({
          if (totalOrders != null) 'totalOrders': totalOrders,
          if (totalEarnings != null) 'totalEarnings': totalEarnings,
          if (vipProgress != null) 'vipProgress': vipProgress,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update VIP progress: $e');
    }
  }

  /// Get all addresses
  static Future<List<dynamic>> getAddresses() async {
    try {
      final headers = await _getHeaders();
      print('🔍 Fetching addresses from: $baseUrl/users/addresses');
      print('🔑 Headers: ${headers.keys.join(", ")}');

      final response = await http
          .get(Uri.parse('$baseUrl/users/addresses'), headers: headers)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Request timeout - check if backend is reachable',
              );
            },
          );

      print('📡 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      final result = _handleResponse(response);
      return result['data'] as List<dynamic>;
    } catch (e) {
      print('❌ Error in getAddresses: $e');
      throw Exception('Failed to get addresses: $e');
    }
  }

  /// Debug: Get all addresses in database (no filtering)
  static Future<Map<String, dynamic>> getAddressesDebug() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users/addresses/debug/all'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to get debug addresses: $e');
    }
  }

  /// Add new address
  static Future<Map<String, dynamic>> addAddress({
    required String label,
    required String address,
    double? latitude,
    double? longitude,
    bool isDefault = false,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'label': label,
        'address': address,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        'isDefault': isDefault,
      };

      print('🔍 Adding address to: $baseUrl/users/addresses');
      print('📤 Request body: $body');

      final response = await http
          .post(
            Uri.parse('$baseUrl/users/addresses'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Request timeout - check if backend is reachable',
              );
            },
          );

      print('📡 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ Error in addAddress: $e');
      throw Exception('Failed to add address: $e');
    }
  }

  /// Delete address
  static Future<Map<String, dynamic>> deleteAddress(String addressId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/users/addresses/$addressId'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  /// Delete all user data (for account deletion)
  static Future<Map<String, dynamic>> deleteUserData() async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/users/data'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to delete user data: $e');
    }
  }

  // ============================================
  // ORDER ENDPOINTS
  // ============================================

  /// Create new order
  static Future<Map<String, dynamic>> createOrder({
    required String orderId,
    required String pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    required String scrapType,
    required double weight,
    required double estimatedPrice,
    String? customerNotes,
    String? customerName,
    String? customerPhone,
    List<String>? imageUrls,
  }) async {
    try {
      final headers = await _getHeaders();

      final body = {
        'orderId': orderId,
        'pickupAddress': pickupAddress,
        if (pickupLatitude != null) 'pickupLatitude': pickupLatitude,
        if (pickupLongitude != null) 'pickupLongitude': pickupLongitude,
        'scrapType': scrapType,
        'weight': weight,
        'estimatedPrice': estimatedPrice,
        if (customerNotes != null) 'customerNotes': customerNotes,
        if (customerName != null) 'customerName': customerName,
        if (customerPhone != null) 'customerPhone': customerPhone,
        if (imageUrls != null && imageUrls.isNotEmpty) 'imageUrls': imageUrls,
      };

      print('📤 Creating order...');
      print('📍 URL: $baseUrl/orders');
      print('📦 Body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: headers,
        body: jsonEncode(body),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e, stackTrace) {
      print('❌ Create order error: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to create order: $e');
    }
  }

  /// Get all orders (optional status filter)
  static Future<List<dynamic>> getOrders({String? status}) async {
    try {
      final headers = await _getHeaders();
      final uri = status != null
          ? Uri.parse('$baseUrl/orders?status=$status')
          : Uri.parse('$baseUrl/orders');

      final response = await http.get(uri, headers: headers);

      final result = _handleResponse(response);
      return result['data'] as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  /// Get single order by ID
  static Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: headers,
      );

      final result = _handleResponse(response);
      return result['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  /// Update order status
  static Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
    double? finalPrice,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/status'),
        headers: headers,
        body: jsonEncode({
          'status': status,
          if (finalPrice != null) 'finalPrice': finalPrice,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Cancel order
  static Future<Map<String, dynamic>> cancelOrder({
    required String orderId,
    String? cancellationReason,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  /// Check backend health
  static Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to check health: $e');
    }
  }

  /// Get public scrap rates (no authentication required)
  static Future<List<dynamic>> getRates() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rates'));
      final result = _handleResponse(response);
      return result['data'] as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to get rates: $e');
    }
  }

  /// Get leaderboard
  static Future<Map<String, dynamic>> getLeaderboard({
    String sortBy = 'totalOrders', // 'totalOrders' or 'earnings'
    int limit = 50,
  }) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse(
        '$baseUrl/admin/leaderboard?sortBy=$sortBy&limit=$limit',
      );

      final response = await http.get(uri, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to get leaderboard: $e');
    }
  }

  /// Get user's rank on leaderboard
  static Future<Map<String, dynamic>> getUserRank() async {
    try {
      final leaderboardData = await getLeaderboard(limit: 1000);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final leaderboard = leaderboardData['data'] as List;
      final userIndex = leaderboard.indexWhere(
        (item) => item['uid'] == user.uid,
      );

      if (userIndex == -1) {
        return {
          'rank': null,
          'totalUsers': leaderboard.length,
          'userData': null,
        };
      }

      return {
        'rank': userIndex + 1,
        'totalUsers': leaderboard.length,
        'userData': leaderboard[userIndex],
      };
    } catch (e) {
      throw Exception('Failed to get user rank: $e');
    }
  }

  /// Handle HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else if (response.statusCode == 401) {
      // Token expired or authentication failed
      final message = data['message'] ?? 'Authentication failed';
      if (message.contains('expired') || message.contains('Token expired')) {
        throw TokenExpiredException(message);
      }
      throw UnauthorizedException(message);
    } else {
      throw Exception(data['message'] ?? 'Request failed');
    }
  }
}

/// Custom exception for token expiration
class TokenExpiredException implements Exception {
  final String message;
  TokenExpiredException(this.message);

  @override
  String toString() => 'TokenExpiredException: $message';
}

/// Custom exception for unauthorized access
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}

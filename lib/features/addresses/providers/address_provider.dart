import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dcrap/core/services/api_service.dart';
import 'package:dcrap/core/services/api_error_handler.dart';
import 'package:flutter/foundation.dart';

class Address {
  final String id;
  final String label; // Home, Work, etc.
  final String line1;
  final String line2;
  final String city;
  final String pinCode;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  const Address({
    required this.id,
    required this.label,
    required this.line1,
    required this.line2,
    required this.city,
    required this.pinCode,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  Address copyWith({
    String? id,
    String? label,
    String? line1,
    String? line2,
    String? city,
    String? pinCode,
    bool? isDefault,
    double? latitude,
    double? longitude,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      pinCode: pinCode ?? this.pinCode,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  // Create Address from backend data
  factory Address.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as String? ?? '';
    final parts = address.split(',').map((e) => e.trim()).toList();

    return Address(
      id: json['_id'] as String? ?? '',
      label: json['label'] as String? ?? 'Address',
      line1: parts.isNotEmpty ? parts[0] : address,
      line2: parts.length > 1 ? parts[1] : '',
      city: parts.length > 2 ? parts[2] : '',
      pinCode: parts.length > 3 ? parts[3] : '',
      isDefault: json['isDefault'] as bool? ?? false,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  // Convert to backend format
  String get fullAddress =>
      [line1, line2, city, pinCode].where((s) => s.isNotEmpty).join(', ');
}

class AddressesController extends StateNotifier<List<Address>> {
  AddressesController() : super([]) {
    loadAddresses();
  }

  // Load addresses from backend
  Future<void> loadAddresses() async {
    try {
      debugPrint('🔍 Loading addresses from backend...');
      final addresses = await ApiErrorHandler.call(
        () => ApiService.getAddresses(),
      );
      state = addresses.map((json) => Address.fromJson(json)).toList();
      debugPrint('✅ Loaded ${state.length} addresses from backend');

      // Debug: Print each address with its firebaseUid if available
      for (var i = 0; i < addresses.length; i++) {
        final json = addresses[i] as Map<String, dynamic>;
        debugPrint(
          '  Address $i: ${json['label']} (UID: ${json['firebaseUid']})',
        );
      }
    } on TokenExpiredException {
      debugPrint('🔴 Token expired - user will be logged out');
      // StreamBuilder in main.dart will automatically navigate to login
    } on UnauthorizedException {
      debugPrint('🔴 Unauthorized - user will be logged out');
    } catch (e) {
      debugPrint('⚠️ Failed to load addresses from backend: $e');
      // Keep current state if load fails
    }
  }

  // Add address to backend and local state
  Future<void> add(Address a) async {
    try {
      await ApiService.addAddress(
        label: a.label,
        address: a.fullAddress,
        latitude: a.latitude,
        longitude: a.longitude,
        isDefault: a.isDefault,
      );

      debugPrint('✅ Address added to backend');

      // Reload addresses to get updated list with correct IDs
      await loadAddresses();
    } catch (e) {
      debugPrint('❌ Failed to add address to backend: $e');
      // Add to local state anyway as fallback
      state = [...state, a];
    }
  }

  // Remove address from backend and local state
  Future<void> remove(String id) async {
    try {
      await ApiService.deleteAddress(id);
      debugPrint('✅ Address deleted from backend');
      state = state.where((e) => e.id != id).toList();
    } catch (e) {
      debugPrint('❌ Failed to delete address from backend: $e');
      // Remove from local state anyway
      state = state.where((e) => e.id != id).toList();
    }
  }

  // Set default address
  Future<void> setDefault(String id) async {
    // Update local state immediately for UI responsiveness
    state = [for (final a in state) a.copyWith(isDefault: a.id == id)];

    // Find the address to set as default
    final defaultAddress = state.firstWhere((a) => a.id == id);

    try {
      // Re-add with isDefault = true (backend will handle removing default from others)
      await ApiService.addAddress(
        label: defaultAddress.label,
        address: defaultAddress.fullAddress,
        latitude: defaultAddress.latitude,
        longitude: defaultAddress.longitude,
        isDefault: true,
      );
      debugPrint('✅ Default address updated in backend');

      // Reload to sync with backend
      await loadAddresses();
    } catch (e) {
      debugPrint('⚠️ Failed to update default address in backend: $e');
      // Local state already updated
    }
  }

  void update(Address updated) {
    state = [
      for (final a in state)
        if (a.id == updated.id) updated else a,
    ];
  }
}

final addressesProvider =
    StateNotifierProvider<AddressesController, List<Address>>(
      (ref) => AddressesController(),
    );

// Optional selection index (if you use it elsewhere)
final selectedAddressIndexProvider = StateProvider<int?>((ref) => null);

// Derived selected address (default > selected index > last)
final selectedAddressProvider = Provider<Address?>((ref) {
  final list = ref.watch(addressesProvider);
  if (list.isEmpty) return null;

  Address? def;
  for (final a in list) {
    if (a.isDefault) {
      def = a;
      break;
    }
  }
  final selIdx = ref.watch(selectedAddressIndexProvider);
  if (def != null) return def;
  if (selIdx != null && selIdx >= 0 && selIdx < list.length) {
    return list[selIdx];
  }
  return list.last;
});

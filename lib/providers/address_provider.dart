import 'package:flutter_riverpod/flutter_riverpod.dart';

class Address {
  final String id;
  final String label; // Home, Work, etc.
  final String line1;
  final String line2;
  final String city;
  final String pinCode;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.line1,
    required this.line2,
    required this.city,
    required this.pinCode,
    this.isDefault = false,
  });

  Address copyWith({
    String? id,
    String? label,
    String? line1,
    String? line2,
    String? city,
    String? pinCode,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      pinCode: pinCode ?? this.pinCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class AddressesController extends StateNotifier<List<Address>> {
  AddressesController()
      : super(const [
          Address(
            id: 'a-home',
            label: 'Home',
            line1: '12 Park Ave',
            line2: 'Near Green Mall',
            city: 'Bhubaneswar',
            pinCode: '751001',
            isDefault: true,
          ),
        ]);

  void add(Address a) => state = [...state, a];

  void remove(String id) => state = state.where((e) => e.id != id).toList();

  void setDefault(String id) {
    state = [
      for (final a in state) a.copyWith(isDefault: a.id == id),
    ];
  }

  void update(Address updated) {
    state = [
      for (final a in state) if (a.id == updated.id) updated else a,
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
  if (selIdx != null && selIdx >= 0 && selIdx < list.length) return list[selIdx];
  return list.last;
});

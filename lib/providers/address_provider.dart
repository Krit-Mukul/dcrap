import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedAddressesProvider =
    StateNotifierProvider<SavedAddressesNotifier, List<Map<String, String>>>(
      (ref) => SavedAddressesNotifier(),
    );

class SavedAddressesNotifier extends StateNotifier<List<Map<String, String>>> {
  SavedAddressesNotifier() : super([]);

  void addAddress(Map<String, String> address) {
    state = [...state, address];
  }
}

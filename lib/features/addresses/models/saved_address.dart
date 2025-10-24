class SavedAddress {
  final String label;
  final String address;
  final String pincode;

  SavedAddress({
    required this.label,
    required this.address,
    required this.pincode,
  });

  SavedAddress copyWith({String? label, String? address, String? pincode}) {
    return SavedAddress(
      label: label ?? this.label,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
    );
  }
}

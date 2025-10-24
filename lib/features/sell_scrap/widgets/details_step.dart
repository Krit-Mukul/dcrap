import 'package:flutter/material.dart';
import 'package:dcrap/features/addresses/models/saved_address.dart';
import '../models/scrap_item.dart';
import 'add_address_sheet.dart';

class DetailsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final List<SavedAddress> savedAddresses;
  final SavedAddress? selectedAddress;
  final Function(SavedAddress) onAddressSelected;
  final Function(SavedAddress) onAddAddress;
  final bool autoEnabled;
  final int autoInterval;
  final String autoUnit;
  final Function(bool) onAutoToggle;
  final VoidCallback onConfigureAuto;
  final List<ScrapItem> items;
  final double estimate;

  const DetailsStep({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.savedAddresses,
    required this.selectedAddress,
    required this.onAddressSelected,
    required this.onAddAddress,
    required this.autoEnabled,
    required this.autoInterval,
    required this.autoUnit,
    required this.onAutoToggle,
    required this.onConfigureAuto,
    required this.items,
    required this.estimate,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your details for pickup',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Full name',
              prefixIcon: const Icon(Icons.person_outline),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFECECEC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFECECEC)),
              ),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone number',
              prefixIcon: const Icon(Icons.phone_outlined),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFECECEC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFECECEC)),
              ),
            ),
            validator: (v) =>
                (v == null || v.trim().length < 8) ? 'Enter valid phone' : null,
          ),
          const SizedBox(height: 24),

          // Saved Addresses Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pickup Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              TextButton.icon(
                onPressed: () => _openAddAddressSheet(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add New'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Saved Address Cards
          ...savedAddresses.map((address) {
            final isSelected = selectedAddress == address;
            return GestureDetector(
              onTap: () => onAddressSelected(address),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : const Color(0xFFECECEC),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF10B981)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        address.label == 'Home'
                            ? Icons.home_outlined
                            : Icons.business_outlined,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address.address,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'PIN: ${address.pincode}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: Color(0xFF10B981)),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          // Auto pickup section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: autoEnabled
                  ? const Color(0xFF10B981).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: autoEnabled
                    ? const Color(0xFF10B981)
                    : const Color(0xFFECECEC),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: autoEnabled
                            ? const Color(0xFF10B981)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.event_repeat,
                        color: autoEnabled
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Auto Pickup',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            autoEnabled
                                ? 'Every $autoInterval $autoUnit'
                                : 'Schedule recurring pickups',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: autoEnabled,
                      onChanged: onAutoToggle,
                      activeColor: const Color(0xFF10B981),
                    ),
                  ],
                ),
                if (autoEnabled) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: onConfigureAuto,
                    icon: const Icon(Icons.settings),
                    label: const Text('Configure schedule'),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF10B981)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${items.length} items',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Weight',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text(
                      '${items.fold(0.0, (sum, e) => sum + e.weightKg).toStringAsFixed(1)} kg',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated Amount',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text(
                      '₹${estimate.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openAddAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddAddressSheet(onSave: onAddAddress),
    );
  }
}

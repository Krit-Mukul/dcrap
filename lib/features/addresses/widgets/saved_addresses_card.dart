import 'package:dcrap/features/addresses/screens/saved_addresses_page.dart';
import 'package:dcrap/features/addresses/providers/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedAddressesCard extends ConsumerWidget {
  const SavedAddressesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECECEC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TitleRow(),
          const SizedBox(height: 10),
          if (addresses.isEmpty)
            _EmptyState(
              onAdd: () {
                ref
                    .read(addressesProvider.notifier)
                    .add(
                      Address(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        label: 'New address',
                        line1: 'Street name',
                        line2: 'Area / Landmark',
                        city: 'City',
                        pinCode: '000000',
                      ),
                    );
              },
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final a = addresses[i];
                return _AddressTile(address: a);
              },
            ),
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_rounded, color: Colors.black87),
        const SizedBox(width: 8),
        const Text(
          'Saved addresses',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SavedAddressesPage()),
            );
          },
          icon: const Icon(Icons.edit_location_alt_rounded, size: 18),
          label: const Text('Manage'),
        ),
      ],
    );
  }
}

class _AddressTile extends ConsumerWidget {
  final Address address;
  const _AddressTile({required this.address});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(addressesProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFECECEC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              address.label.toLowerCase().contains('work')
                  ? Icons.work_rounded
                  : Icons.home_rounded,
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (address.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Default',
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${address.line1}, ${address.line2}',
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                Text(
                  '${address.city} · ${address.pinCode}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (!address.isDefault)
            TextButton(
              onPressed: () => ctrl.setDefault(address.id),
              child: const Text('Set default'),
            ),
          IconButton(
            tooltip: 'Delete',
            onPressed: () => ctrl.remove(address.id),
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFECECEC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.black54),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'You have no saved addresses yet.',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/address_provider.dart';
import 'address_details_screen.dart';

class SavedAddressesPage extends ConsumerWidget {
  const SavedAddressesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider);
    final selectedIdx = ref.watch(selectedAddressIndexProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddressDetailsScreen(currentLocation: ''),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add new'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: addresses.length == 0 ? 1 : addresses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          if (addresses.isEmpty) {
            return _EmptyState(onAdd: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddressDetailsScreen(currentLocation: ''),
                ),
              );
            });
          }

          final a = addresses[i];
          final isDefault = selectedIdx != null && selectedIdx == i;
          final scheme = Theme.of(context).colorScheme;

          return Container(
            padding: const EdgeInsets.all(14),
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
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: scheme.primary.withOpacity(.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _iconForLabel(a.label),
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              a.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                        '${a.line1}, ${a.line2}',
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${a.city} · ${a.pinCode}',
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (!isDefault)
                            TextButton(
                              onPressed: () {
                                ref.read(selectedAddressIndexProvider.notifier).state = i;
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(content: Text('Default address set')));
                              },
                              child: const Text('Set default'),
                            ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              ref.read(addressesProvider.notifier).remove(a.id);
                              final sel = ref.read(selectedAddressIndexProvider);
                              if (sel != null) {
                                if (addresses.length == 1) {
                                  ref.read(selectedAddressIndexProvider.notifier).state = null;
                                } else if (i < sel) {
                                  ref.read(selectedAddressIndexProvider.notifier).state = sel - 1;
                                } else if (i == sel) {
                                  ref.read(selectedAddressIndexProvider.notifier).state =
                                      (sel >= (addresses.length - 1)) ? addresses.length - 2 : sel;
                                }
                              }
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
      child: Row(
        children: [
          Icon(Icons.location_off_rounded, color: scheme.primary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'No saved addresses yet.',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

_iconForLabel(String label) {
  switch (label.toLowerCase()) {
    case 'work':
      return Icons.work_rounded;
    case 'home':
    default:
      return Icons.home_rounded;
  }
}
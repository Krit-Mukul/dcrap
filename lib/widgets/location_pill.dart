import 'package:dcrap/pages/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/address_provider.dart';

class LocationPill extends ConsumerWidget {
  const LocationPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the list of saved addresses
    final savedAddresses = ref.watch(savedAddressesProvider);

    // Get the most recent address, or show a default message if none exist
    final recentAddress = savedAddresses.isNotEmpty
        ? savedAddresses.last
        : {'tag': 'No Tag', 'house': 'No address', 'street': ''};

    return GestureDetector(
      onTap: () {
        // Navigate to the location screen or another action
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const LocationScreen()));
      },
      child: Container(
        height: 60, // Fixed height for the LocationPill
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
              Theme.of(context).colorScheme.secondaryContainer.withAlpha(150),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: const Color(0xFFECECEC)),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_rounded),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    recentAddress['tag'] ?? 'No Tag',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${recentAddress['house']}, ${recentAddress['street']}',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

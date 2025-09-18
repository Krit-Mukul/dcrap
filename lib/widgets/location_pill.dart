import 'package:dcrap/pages/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/address_provider.dart';

class LocationPill extends ConsumerWidget {
  const LocationPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Selected Address? (can be null)
    final selected = ref.watch(selectedAddressProvider);

    return GestureDetector(
      onTap:() {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LocationScreen()),
        );
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          // color: Colors.white,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
              Theme.of(context).colorScheme.secondaryContainer.withAlpha(150),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(28),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withAlpha(18),
          //     blurRadius: 12,
          //     offset: const Offset(0, 6),
          //   ),
          // ],
          // border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Row(
                    children: [
            const Icon(Icons.location_on_rounded, size: 16,),
                      Text(
                        selected?.label.isNotEmpty == true ? selected!.label : 'Select address',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
            const Icon(Icons.chevron_right_rounded, size: 20),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        selected == null
                            ? 'Tap to add address'
                            : '${selected.line1}${selected.line1.isNotEmpty && selected.line2.isNotEmpty ? ', ' : ''}${selected.line2}',
                        style: const TextStyle(fontSize: 10, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}

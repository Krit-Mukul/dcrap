import 'package:flutter/material.dart';

class AutoPickupPage extends StatelessWidget {
  const AutoPickupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Automatic Pickups')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.event_repeat_rounded, color: scheme.primary),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Set up recurring pickups (e.g., every 2 weeks). View, edit, or cancel your schedules.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  'No automatic pickups yet',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Coming soon')));
                },
                icon: const Icon(Icons.add),
                label: const Text('Set up automatic pickup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

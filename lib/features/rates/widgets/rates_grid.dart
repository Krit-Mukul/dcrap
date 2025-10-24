import 'package:dcrap/features/rates/models/rate_item.dart';
import 'package:dcrap/features/rates/screens/rates_detail_screen.dart';
import 'package:flutter/material.dart';

class RatesGridCard extends StatelessWidget {
  const RatesGridCard({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <RateItem>[
      RateItem(
        'Aluminum',
        Icons.cookie_rounded,
        135,
        160,
        const Color(0xFF3B82F6),
        pastRates: [120, 125, 130, 135, 140, 150, 160],
      ),
      RateItem(
        'Copper',
        Icons.cable_rounded,
        650,
        720,
        const Color(0xFFEF4444),
        pastRates: [600, 620, 640, 650, 680, 700, 720],
      ),
      RateItem(
        'Cardboard',
        Icons.inventory_2_rounded,
        10,
        14,
        const Color(0xFFF59E0B),
        pastRates: [8, 9, 10, 11, 12, 13, 14],
      ),
      RateItem(
        'Plastic',
        Icons.local_drink_rounded,
        18,
        24,
        const Color(0xFF10B981),
        pastRates: [15, 16, 17, 18, 20, 22, 24],
      ),
      RateItem(
        'Steel',
        Icons.construction_rounded,
        45,
        52,
        const Color(0xFF6366F1),
        pastRates: [40, 42, 44, 45, 48, 50, 52],
      ),
      RateItem(
        'E-Waste',
        Icons.devices_rounded,
        85,
        95,
        const Color(0xFF8B5CF6),
        pastRates: [75, 78, 80, 85, 88, 92, 95],
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Market Rates',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RatesDetailPage(allItems: items),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('View All'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length > 4 ? 4 : items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2, // Increased from 1.15 to 1.2
            ),
            itemBuilder: (context, i) {
              final it = items[i];
              final up = it.newPrice >= it.oldPrice;
              final pct = it.oldPrice == 0
                  ? 0
                  : ((it.newPrice - it.oldPrice) / it.oldPrice) * 100;

              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            RatesDetailPage(allItems: items, initialIndex: i),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFECECEC)),
                      gradient: LinearGradient(
                        colors: [it.tint.withAlpha(15), it.tint.withAlpha(5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Changed from mainAxisSize
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: it.tint.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(it.icon, color: it.tint, size: 20),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: up
                                    ? const Color(0xFF10B981).withAlpha(25)
                                    : Colors.red.withAlpha(25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    up
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded,
                                    size: 10,
                                    color: up
                                        ? const Color(0xFF10B981)
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${pct.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: up
                                          ? const Color(0xFF10B981)
                                          : Colors.red,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              it.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            // const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  '₹${it.oldPrice.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    '₹${it.newPrice.toStringAsFixed(0)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF10B981),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'per kg',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:dcrap/models/rate_item.dart';
import 'package:flutter/material.dart';

class RatesGridCard extends StatelessWidget {
  const RatesGridCard({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: Colors.black87,
    );

    final items = <RateItem>[
      RateItem(
        'Aluminum',
        Icons.cookie_rounded,
        135,
        160,
        const Color(0xFF3B82F6),
      ),
      RateItem(
        'Copper',
        Icons.cable_rounded,
        650,
        720,
        const Color(0xFFEF4444),
      ),
      RateItem(
        'Cardboard',
        Icons.inventory_2_rounded,
        10,
        14,
        const Color(0xFFF59E0B),
      ),
      RateItem(
        'Plastic',
        Icons.local_drink_rounded,
        18,
        24,
        const Color(0xFF10B981),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(14), // reduced padding slightly
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECECEC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Know your scrap',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('View all coming soon')),
                  );
                },
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3.5, // wider items
            ),
            itemBuilder: (context, i) {
              final it = items[i];
              final up = it.newPrice >= it.oldPrice;
              final pct = it.oldPrice == 0
                  ? 0
                  : ((it.newPrice - it.oldPrice) / it.oldPrice) * 100;

              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening ${it.name} details...')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10), // reduced padding
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFECECEC)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: it.tint.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            it.icon,
                            color: it.tint,
                            size: 22,
                          ), // smaller icon
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                it.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13, // reduced
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    '₹${it.oldPrice.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 11, // reduced
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '₹${it.newPrice.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Color(0xFF1F8F2E),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12, // reduced
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        up
                                            ? Icons.trending_up_rounded
                                            : Icons.trending_down_rounded,
                                        size: 14, // reduced
                                        color: up
                                            ? const Color(0xFF1F8F2E)
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${up ? '+' : ''}${pct.toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          color: up
                                              ? const Color(0xFF1F8F2E)
                                              : Colors.red,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11, // reduced
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
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

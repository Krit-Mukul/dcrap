import 'package:dcrap/features/rates/screens/rates_detail_screen.dart';
import 'package:dcrap/features/rates/providers/rates_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RatesGridCard extends ConsumerStatefulWidget {
  const RatesGridCard({super.key});

  @override
  ConsumerState<RatesGridCard> createState() => _RatesGridCardState();
}

class _RatesGridCardState extends ConsumerState<RatesGridCard> {
  @override
  void initState() {
    super.initState();
    // Fetch rates when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ratesProvider.notifier).fetchRates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratesState = ref.watch(ratesProvider);
    final items = ratesState.rates;
    final isLoading = ratesState.isLoading;
    final errorMessage = ratesState.errorMessage;

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
              if (!isLoading && items.isNotEmpty)
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

          // Loading state
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
          // Error state
          else if (errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(ratesProvider.notifier).fetchRates();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          // Data loaded successfully
          else if (items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  'No rates available',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            )
          // Display rates grid
          else
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length > 4 ? 4 : items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  const SizedBox(width: 4),
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

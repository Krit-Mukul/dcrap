import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final transactions = <Map<String, dynamic>>[
      {'title': 'Scrap sale - Aluminum', 'subtitle': 'Order #A1290', 'amount': 420.00, 'positive': true, 'icon': Icons.recycling_rounded},
      {'title': 'Pickup fee', 'subtitle': 'Order #A1290', 'amount': -50.00, 'positive': false, 'icon': Icons.local_shipping_rounded},
      {'title': 'Scrap sale - Cardboard', 'subtitle': 'Order #C5832', 'amount': 180.00, 'positive': true, 'icon': Icons.inventory_2_rounded},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: ListView(
        
        padding: const EdgeInsets.all(16),
        children: [
          // Balance card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFECECEC)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.account_balance_wallet_rounded, color: scheme.primary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Wallet balance', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black54)),
                      SizedBox(height: 4),
                      Text('₹ 1,250.00', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
                    ],
                  ),
                ),
                // FilledButton(
                //   onPressed: () {},
                //   child: const Text('Add money'),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Actions row
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Expanded(
              //   child: 
              // ),
              Expanded(
                child: FilledButton(
                    onPressed: () {},
                    // icon: const Icon(Icons.file_download_rounded),
                    child: const Text('Withdraw'),
                  ),
              ),
              const SizedBox(width: 12),
              // Expanded(
              //   child: OutlinedButton.icon(
              //     onPressed: () {},
              //     icon: const Icon(Icons.receipt_long_rounded),
              //     label: const Text('History'),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 16),

          // Transactions header
          const Text('Recent transactions', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),

          // Transactions list
          ...transactions.map((t) {
            final positive = t['positive'] as bool;
            final amount = (t['amount'] as double);
            final color = positive ? const Color(0xFF1F8F2E) : Colors.red;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFECECEC)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(t['icon'] as IconData, color: scheme.primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t['title'] as String, style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(t['subtitle'] as String, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    (positive ? '+' : '') + '₹ ${amount.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.w800, color: color),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
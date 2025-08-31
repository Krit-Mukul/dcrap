import 'package:dcrap/pages/sell_scrap_page.dart';
import 'package:dcrap/widgets/benefit.dart';
import 'package:dcrap/widgets/cta_button.dart';
import 'package:flutter/material.dart';

class BenefitsCard extends StatelessWidget {
  const BenefitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF1F8F2E);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8F8EB), Color(0xFFD9F5DE), Color(0xFFCFF3D4)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Benefit(
                icon: Icons.bolt_rounded,
                labelTop: 'Fast and',
                labelBottom: 'reliable',
              ),
              Benefit(
                icon: Icons.local_shipping_rounded,
                labelTop: 'Doorstep',
                labelBottom: 'pickup',
              ),
              Benefit(
                icon: Icons.attach_money_rounded,
                labelTop: 'Best market',
                labelBottom: 'rates',
              ),
            ],
          ),
          const SizedBox(height: 12),
          CtaButton(
            title: 'Sell your scrap now',
            color: Theme.of(context).colorScheme.primary,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SellScrapPage()));
            },
          ),
        ],
      ),
    );
  }
}

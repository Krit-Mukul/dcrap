import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:dcrap/features/profile/screens/profile_screen.dart';
import 'package:dcrap/features/wallet/screens/wallet_screen.dart';
import 'package:dcrap/features/home/widgets/benefits_card.dart';
import 'package:dcrap/features/home/widgets/ghost_card.dart';
import 'package:dcrap/features/home/widgets/headline.dart';
import 'package:dcrap/features/home/widgets/location_pill.dart';
import 'package:dcrap/features/rates/widgets/rates_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Full-bleed Location pill (slight safe padding)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: LocationPill(
                            // onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 6),
                        _walletIcon(context), // new wallet icon
                        const SizedBox(width: 6),
                        _profileIcon(context),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Rest of the page keeps the original 18px horizontal padding
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Headline(),
                      const SizedBox(height: 4),
                      Center(
                        child: SizedBox(
                          height: 200,
                          child: Lottie.asset(
                            'assets/lottie_machine.json',
                            repeat: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Value Beyond Waste',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'Turning everyday scrap into assured returns.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 50),
                      const BenefitsCard(),
                      const SizedBox(height: 16),
                      const RatesGridCard(),
                      const SizedBox(height: 16),
                      GhostCard(
                        height: 110,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.eco_rounded,
                                size: 40,
                                color: Color(0xFF25A332),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Environmental Impact',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'You have helped save 12kg CO₂ and recycled 25kg waste!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Rewards Card
                      GhostCard(
                        height: 110,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.card_giftcard_rounded,
                                size: 40,
                                color: Colors.orangeAccent,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Your Rewards',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'You have earned 5 coupons and ₹250 cashback!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Trending Market Scrap Card
                      GhostCard(
                        height: 110,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                                size: 40,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Trending Market Scrap',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Copper prices up 8% this week. Sell now for best rates!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Eco Tips Card
                      GhostCard(
                        height: 110,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lightbulb_rounded,
                                size: 40,
                                color: Colors.greenAccent,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Eco Tips',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Segregate your waste and use reusable bags!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(progress: 0.65),
          ),
        );
      },
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withAlpha(230),
              Theme.of(context).colorScheme.primary.withAlpha(180),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.person_rounded, size: 30, color: Colors.white),
      ),
    );
  }

  Widget _walletIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const WalletPage()));
      },
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFFFFA726).withAlpha(230),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFA726).withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.account_balance_wallet_rounded,
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}

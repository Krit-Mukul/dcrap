import 'package:dcrap/widgets/benefits_card.dart';
import 'package:dcrap/widgets/ghost_card.dart';
import 'package:dcrap/widgets/headline.dart';
import 'package:dcrap/widgets/location_pill.dart';
import 'package:dcrap/widgets/rates_grid.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment(0, .35),
        //     colors: [Color(0xFF93E3F3), Color(0xFFEFF7F9)],
        //   ),
        // ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Full-bleed Location pill (slight safe padding)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: LocationPill(),
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
                      // Add Lottie animation below headline
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 1.2,
                        ),
                      ),
                      // const SizedBox(height: 50),
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
                      // _GhostCard(
                      //   height: size.width * 0.28,
                      //   child: const Center(
                      //     child: Text(
                      //       'dcrap',
                      //       style: TextStyle(
                      //         fontSize: 34,
                      //         fontWeight: FontWeight.w800,
                      //         letterSpacing: 1.0,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 18),
                      const BenefitsCard(),
                      const SizedBox(height: 16),

                      // NEW: Growing scrap rates grid
                      const RatesGridCard(),
                      const SizedBox(height: 16),

                      // Environmental Impact Card
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
}
import 'package:dcrap/pages/sell_scrap_page.dart';
import 'package:dcrap/pages/vip_progress_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const DcrapApp());

class DcrapApp extends StatelessWidget {
  const DcrapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dcrap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF137B2F)),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment(0, .35),
            colors: [Color(0xFF93E3F3), Color(0xFFEFF7F9)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            // was: EdgeInsets.symmetric(horizontal: 18, vertical: 16)
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Full-bleed Location pill (slight safe padding)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: _LocationPill(),
                ),
                const SizedBox(height: 16),

                // Rest of the page keeps the original 18px horizontal padding
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Headline(),
                      const SizedBox(height: 4),
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
                      _GhostCard(
                        height: size.width * 0.28,
                        child: const Center(
                          child: Text(
                            'dcrap',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _BenefitsCard(),
                      const SizedBox(height: 16),

                      // NEW: Growing scrap rates grid
                      const _RatesGridCard(),
                      const SizedBox(height: 16),

                      // Environmental Impact Card
                      _GhostCard(
                        height: 110,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          child: Row(
                            children: [
                              Icon(Icons.eco_rounded, size: 40, color: Color(0xFF25A332)),
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
                      _GhostCard(
                        height: 110,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          child: Row(
                            children: [
                              Icon(Icons.card_giftcard_rounded, size: 40, color: Colors.orangeAccent),
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
                      _GhostCard(
                        height: 110,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          child: Row(
                            children: [
                              Icon(Icons.trending_up_rounded, size: 40, color: Colors.deepPurple),
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
                      _GhostCard(
                        height: 110,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_rounded, size: 40, color: Colors.greenAccent),
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

class _LocationPill extends StatelessWidget {
  const _LocationPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.07),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFFECECEC)),
      ),
      child: Row(
        children: [
          _circleIcon(context, icon: Icons.location_on_rounded),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Location',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                SizedBox(height: 2),
                Text(
                  'Thapar University, Patiala',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // 👉 Make profile icon open the VIP progress page
          _circleIcon(
            context,
            icon: Icons.person_rounded,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VipProgressPage(
                    progress: 0.65,
                  ), // pass real progress here
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _circleIcon(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final child = Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Icon(icon, size: 18, color: Colors.black87),
    );

    return onTap == null
        ? child
        : Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: child,
            ),
          );
  }
}

class _Headline extends StatefulWidget {
  const _Headline();

  @override
  State<_Headline> createState() => _HeadlineState();
}

class _HeadlineState extends State<_Headline> with TickerProviderStateMixin {
  late AnimationController _outCtrl;
  late AnimationController _inCtrl;

  // Current word being shown
  String _currentWord = 'REWARDING';
  bool _nextIsRewarding = false; // next word toggle
  _Phase _phase = _Phase.hold;

  @override
  void initState() {
    super.initState();
    _outCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _inCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _startCycle(); // begin hold -> out -> in -> repeat
  }

  @override
  void dispose() {
    _outCtrl.dispose();
    _inCtrl.dispose();
    super.dispose();
  }

  Future<void> _startCycle() async {
    while (mounted) {
      // Hold (word steady)
      _phase = _Phase.hold;
      if (mounted) setState(() {});
      await Future.delayed(const Duration(milliseconds: 1200));

      // Slide current word out to the right
      _phase = _Phase.out;
      _outCtrl.value = 0;
      if (mounted) setState(() {});
      await _outCtrl.forward();

      // Swap word after it fully leaves
      _currentWord = _nextIsRewarding ? 'REWARDING' : 'EASIER';
      _nextIsRewarding = !_nextIsRewarding;

      // Slide new word in from the left to center (moving right)
      _phase = _Phase.slideIn;
      _inCtrl.value = 0;
      if (mounted) setState(() {});
      await _inCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = const TextStyle(
      fontSize: 21,
      letterSpacing: .3,
      fontWeight: FontWeight.w800,
      color: Colors.black,
    );

    // Drive UI from both controllers
    return AnimatedBuilder(
      animation: Listenable.merge([_outCtrl, _inCtrl]),
      builder: (context, _) {
        // Compute horizontal fractional translation
        double dx = 0;
        switch (_phase) {
          case _Phase.hold:
            dx = 0;
            break;
          case _Phase.out:
            dx = _outCtrl.value * 1.2; // 0 -> +1.2 (move right off-screen)
            break;
          case _Phase.slideIn:
            dx = -1.2 + _inCtrl.value * 1.2; // -1.2 -> 0 (enter from left moving right)
            break;
        }

        return Column(
          children: [
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('RECYCLING MADE ', style: baseStyle, textAlign: TextAlign.left),
                  // Clip so text can slide fully off without affecting layout
                  ClipRect(
                    child: FractionalTranslation(
                      translation: Offset(dx, 0),
                      child: Text(
                        _currentWord,
                        style: baseStyle.copyWith(color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

enum _Phase { hold, out, slideIn }

class _GhostCard extends StatelessWidget {
  final double height;
  final Widget? child;

  const _GhostCard({required this.height, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // Changed to white
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard();

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
            color: Colors.black.withOpacity(.10),
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
              _Benefit(
                icon: Icons.bolt_rounded,
                labelTop: 'Fast and',
                labelBottom: 'reliable',
              ),
              _Benefit(
                icon: Icons.local_shipping_rounded,
                labelTop: 'Doorstep',
                labelBottom: 'pickup',
              ),
              _Benefit(
                icon: Icons.attach_money_rounded,
                labelTop: 'Best market',
                labelBottom: 'rates',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _CtaButton(
            title: 'Sell your scrap now',
            color: Theme.of(context).colorScheme.primary,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SellScrapPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  final IconData icon;
  final String labelTop;
  final String labelBottom;

  const _Benefit({
    required this.icon,
    required this.labelTop,
    required this.labelBottom,
  });

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFF3A3A3A),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.circle, color: Colors.transparent),
    );

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            circle,
            Icon(icon, color: Colors.white, size: 28),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          labelTop,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
        Text(
          labelBottom,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}

class _CtaButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;

  const _CtaButton({
    required this.title,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: const [
              Expanded(
                child: Text(
                  'Sell your scrap now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================================
/// VIP Progress Screen
/// ===============================================

class _RatesGridCard extends StatelessWidget {
  const _RatesGridCard();

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        );

    final items = <_RateItem>[
      _RateItem('Aluminum', Icons.cookie_rounded, 135, 160, const Color(0xFF3B82F6)),
      _RateItem('Copper', Icons.cable_rounded, 650, 720, const Color(0xFFEF4444)),
      _RateItem('Cardboard', Icons.inventory_2_rounded, 10, 14, const Color(0xFFF59E0B)),
      _RateItem('Plastic', Icons.local_drink_rounded, 18, 24, const Color(0xFF10B981)),
    ];

    return Container(
      padding: const EdgeInsets.all(14), // reduced padding slightly
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECECEC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
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
              Text('Know your scrap', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  )),
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
              final pct = it.oldPrice == 0 ? 0 : ((it.newPrice - it.oldPrice) / it.oldPrice) * 100;

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
                            color: it.tint.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(it.icon, color: it.tint, size: 22), // smaller icon
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
                                        up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                                        size: 14, // reduced
                                        color: up ? const Color(0xFF1F8F2E) : Colors.red,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${up ? '+' : ''}${pct.toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          color: up ? const Color(0xFF1F8F2E) : Colors.red,
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

class _RateItem {
  final String name;
  final IconData icon;
  final double oldPrice;
  final double newPrice;
  final Color tint;
  _RateItem(this.name, this.icon, this.oldPrice, this.newPrice, this.tint);
}

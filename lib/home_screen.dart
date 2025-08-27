import 'package:flutter/material.dart';

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
            colors: [
              Color(0xFF93E3F3), // light cyan
              Color(0xFFEFF7F9), // fades to white
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _LocationPill(),
                const SizedBox(height: 16),
                const _Headline(),
                const SizedBox(height: 4),
                Text(
                  'lorem ipsum',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
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
                const SizedBox(height: 24),
                _GhostCard(height: 90),
                const SizedBox(height: 16),
                _GhostCard(height: size.width * 0.6),
                const SizedBox(height: 36),
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
          _circleIcon(
            context,
            icon: Icons.location_on_rounded,
          ),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _circleIcon(
            context,
            icon: Icons.person_rounded,
          ),
        ],
      ),
    );
  }

  static Widget _circleIcon(BuildContext context, {required IconData icon}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Icon(icon, size: 18, color: Colors.black87),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 20,
            letterSpacing: .3,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          children: [
            TextSpan(text: 'RECYCLING MADE '),
            TextSpan(
              text: 'REWARDING',
              style: TextStyle(color: Color(0xFF25A332)),
            ),
          ],
        ),
      ),
    );
  }
}

class _GhostCard extends StatelessWidget {
  final double height;
  final Widget? child;

  const _GhostCard({required this.height, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9),
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
          colors: [
            Color(0xFFE8F8EB), // faint top
            Color(0xFFD9F5DE), // mid
            Color(0xFFCFF3D4), // bottom glow-like
          ],
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
              _Benefit(icon: Icons.bolt_rounded, labelTop: 'Fast and', labelBottom: 'reliable'),
              _Benefit(icon: Icons.local_shipping_rounded, labelTop: 'Doorstep', labelBottom: 'pickup'),
              _Benefit(icon: Icons.attach_money_rounded, labelTop: 'Best market', labelBottom: 'rates'),
            ],
          ),
          const SizedBox(height: 12),
          _CtaButton(
            title: 'Sell your scrap now',
            color: green,
            onTap: () {},
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
      child: const Icon(Icons.circle, color: Colors.transparent), // keeps size
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
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:dcrap/pages/vip_progress_page.dart';
import 'package:flutter/material.dart';

class LocationPill extends StatelessWidget {
  const LocationPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
            Theme.of(context).colorScheme.secondaryContainer.withAlpha(150),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        // color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .07),
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

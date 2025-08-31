import 'package:flutter/material.dart';

class Benefit extends StatelessWidget {
  final IconData icon;
  final String labelTop;
  final String labelBottom;

  const Benefit({
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
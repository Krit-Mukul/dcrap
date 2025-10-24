import 'package:flutter/material.dart';

class Benefit extends StatelessWidget {
  final IconData icon;
  final String labelTop;
  final String labelBottom;

  const Benefit({
    required this.icon,
    required this.labelTop,
    required this.labelBottom,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
            Icon(icon, color: Colors.amber.withAlpha(250), size: 36),
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
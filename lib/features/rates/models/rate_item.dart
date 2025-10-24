import 'package:flutter/widgets.dart';

class RateItem {
  final String name;
  final IconData icon;
  final double oldPrice;
  final double newPrice;
  final Color tint;
  final List<double> pastRates; // Added field for past rates

  RateItem(
    this.name,
    this.icon,
    this.oldPrice,
    this.newPrice,
    this.tint, {
    required this.pastRates, // Marked as required
  });
}

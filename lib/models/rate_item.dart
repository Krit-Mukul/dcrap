import 'package:flutter/widgets.dart';

class RateItem {
  final String name;
  final IconData icon;
  final double oldPrice;
  final double newPrice;
  final Color tint;
  RateItem(this.name, this.icon, this.oldPrice, this.newPrice, this.tint);
}
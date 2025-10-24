import 'package:flutter/material.dart';

class ScrapRates {
  static const Map<String, Map<String, dynamic>> ratesPerKg = {
    'Newspaper': {
      'rate': 12.0,
      'icon': Icons.article_outlined,
      'color': Color(0xFF3B82F6),
    },
    'Cardboard': {
      'rate': 10.0,
      'icon': Icons.inventory_2_outlined,
      'color': Color(0xFFF59E0B),
    },
    'Plastic': {
      'rate': 8.0,
      'icon': Icons.local_drink_outlined,
      'color': Color(0xFF10B981),
    },
    'Metal': {
      'rate': 25.0,
      'icon': Icons.settings_outlined,
      'color': Color(0xFF6366F1),
    },
    'E-waste': {
      'rate': 30.0,
      'icon': Icons.devices_outlined,
      'color': Color(0xFFEF4444),
    },
  };

  static double getRateForType(String type) {
    return ratesPerKg[type]?['rate'] as double? ?? 0.0;
  }

  static IconData getIconForType(String type) {
    return ratesPerKg[type]?['icon'] as IconData? ?? Icons.help_outline;
  }

  static Color getColorForType(String type) {
    return ratesPerKg[type]?['color'] as Color? ?? Colors.grey;
  }
}

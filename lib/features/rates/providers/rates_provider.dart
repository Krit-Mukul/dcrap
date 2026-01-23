import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dcrap/core/services/api_service.dart';
import 'package:dcrap/features/rates/models/rate_item.dart';

// State class to hold rates data
class RatesState {
  final List<RateItem> rates;
  final bool isLoading;
  final String? errorMessage;

  RatesState({
    this.rates = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  RatesState copyWith({
    List<RateItem>? rates,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RatesState(
      rates: rates ?? this.rates,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Riverpod provider for rates
class RatesNotifier extends StateNotifier<RatesState> {
  RatesNotifier() : super(RatesState());

  // Map scrap types to icons and colors
  final Map<String, Map<String, dynamic>> _scrapTypeMapping = {
    'Plastic': {
      'icon': Icons.local_drink_rounded,
      'color': const Color(0xFF10B981),
    },
    'Paper': {
      'icon': Icons.description_rounded,
      'color': const Color(0xFF3B82F6),
    },
    'Metal': {
      'icon': Icons.construction_rounded,
      'color': const Color(0xFF6366F1),
    },
    'Glass': {'icon': Icons.wine_bar_rounded, 'color': const Color(0xFF14B8A6)},
    'Electronics': {
      'icon': Icons.devices_rounded,
      'color': const Color(0xFF8B5CF6),
    },
    'Cardboard': {
      'icon': Icons.inventory_2_rounded,
      'color': const Color(0xFFF59E0B),
    },
    'Other': {'icon': Icons.category_rounded, 'color': const Color(0xFF6B7280)},
  };

  Future<void> fetchRates() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final ratesData = await ApiService.getRates();

      final rates = ratesData
          .where(
            (rate) => rate['isActive'] != false,
          ) // Include if isActive is true or missing
          .map((rate) {
            final scrapType = rate['scrapType'] as String;
            final pricePerKg = (rate['pricePerKg'] as num).toDouble();

            // Get icon and color for this scrap type
            final mapping =
                _scrapTypeMapping[scrapType] ?? _scrapTypeMapping['Other']!;

            // Generate past rates for chart (current price +/- some variation)
            final pastRates = _generatePastRates(pricePerKg);

            return RateItem(
              scrapType,
              mapping['icon'] as IconData,
              pastRates[pastRates.length - 2], // Old price (second last)
              pricePerKg, // Current price
              mapping['color'] as Color,
              pastRates: pastRates,
            );
          })
          .toList();

      state = state.copyWith(rates: rates, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to load rates: ${e.toString()}',
        isLoading: false,
      );
      // print('Error fetching rates: $e');
    }
  }

  // Generate simulated past rates for chart display
  List<double> _generatePastRates(double currentPrice) {
    // Generate 7 past rates showing some trend
    List<double> rates = [];
    double basePrice = currentPrice * 0.85; // Start at 85% of current

    for (int i = 0; i < 7; i++) {
      // Gradually increase towards current price with some variation
      double progress = i / 6.0;
      double rate = basePrice + ((currentPrice - basePrice) * progress);

      // Add small random variation (±5%)
      double variation = (rate * 0.05) * ((i % 3) - 1) / 2;
      rate += variation;

      rates.add(double.parse(rate.toStringAsFixed(2)));
    }

    // Ensure last rate is the current price
    rates[6] = currentPrice;

    return rates;
  }

  // Get rate for a specific scrap type
  RateItem? getRateByType(String scrapType) {
    try {
      return state.rates.firstWhere((rate) => rate.name == scrapType);
    } catch (e) {
      return null;
    }
  }

  // Get total scrap types count
  int get totalScrapTypes => state.rates.length;
}

// Provider declaration
final ratesProvider = StateNotifierProvider<RatesNotifier, RatesState>((ref) {
  return RatesNotifier();
});

import 'package:flutter/material.dart';

class ScrapItem {
  final String name;
  final IconData icon;
  final double oldPricePerKg;
  final double newPricePerKg;
  final List<double> history; // oldest -> newest
  final Color tint;
  final String facts;
  final String futurePotential;

  const ScrapItem({
    required this.name,
    required this.icon,
    required this.oldPricePerKg,
    required this.newPricePerKg,
    required this.history,
    required this.tint,
    required this.facts,
    required this.futurePotential,
  });
}

class ScrapRatesData {
  static final List<ScrapItem> all = [
    ScrapItem(
      name: 'Aluminum',
      icon: Icons.cookie_rounded,
      oldPricePerKg: 135,
      newPricePerKg: 160,
      history: [110, 118, 120, 125, 130, 138, 145, 150, 148, 155, 158, 160],
      tint: const Color(0xFF3B82F6),
      facts:
          'Aluminum cans take 200+ years to decompose. Recycling saves up to 95% of the energy required to make new aluminum.',
      futurePotential:
          'EVs and beverage demand keep aluminum bullish. Supply tightness can support prices near-term.',
    ),
    ScrapItem(
      name: 'Copper',
      icon: Icons.cable_rounded,
      oldPricePerKg: 650,
      newPricePerKg: 720,
      history: [590, 600, 615, 620, 640, 655, 660, 670, 690, 700, 710, 720],
      tint: const Color(0xFFEF4444),
      facts:
          'Improper disposal can leach heavy metals into soil and water. Recycling copper reduces mining-driven habitat loss.',
      futurePotential:
          'Grid upgrades and renewables keep copper strong; long-term demand remains robust.',
    ),
    ScrapItem(
      name: 'Cardboard',
      icon: Icons.inventory_2_rounded,
      oldPricePerKg: 10,
      newPricePerKg: 14,
      history: [8, 9, 9, 10, 11, 12, 12, 13, 12, 13, 13, 14],
      tint: const Color(0xFFF59E0B),
      facts:
          'Landfilled paper emits methane, a potent greenhouse gas. Recycling saves trees and water.',
      futurePotential:
          'E‑commerce cycles drive demand; seasonal spikes expected during festivals.',
    ),
    ScrapItem(
      name: 'Plastic',
      icon: Icons.local_drink_rounded,
      oldPricePerKg: 18,
      newPricePerKg: 24,
      history: [14, 15, 15, 16, 17, 17, 18, 20, 19, 21, 23, 24],
      tint: const Color(0xFF10B981),
      facts:
          'Plastic persists for centuries and harms marine life. Recycling reduces microplastic leakage.',
      futurePotential:
          'Regulations on single-use plastics and improved sorting tech can support better pricing.',
    ),
    ScrapItem(
      name: 'Steel',
      icon: Icons.build_rounded,
      oldPricePerKg: 36,
      newPricePerKg: 42,
      history: [30, 31, 32, 34, 33, 35, 36, 37, 38, 40, 41, 42],
      tint: const Color(0xFF8B5CF6),
      facts:
          'Steel production is energy-intensive; recycling reduces CO₂ emissions by ~58%.',
      futurePotential:
          'Infrastructure spend supports steady growth; prices may stabilize at higher base.',
    ),
    ScrapItem(
      name: 'E‑waste',
      icon: Icons.memory_rounded,
      oldPricePerKg: 22,
      newPricePerKg: 28,
      history: [16, 17, 17, 18, 19, 19, 20, 22, 23, 25, 26, 28],
      tint: const Color(0xFF06B6D4),
      facts:
          'Improper e‑waste handling releases toxins like lead and mercury. Proper recycling prevents contamination.',
      futurePotential:
          'Higher collection rates and recovery tech improve margins; demand for rare metals is rising.',
    ),
  ];

  static List<ScrapItem> get trending => all.take(6).toList();
}

class ScrapRatesListPage extends StatelessWidget {
  const ScrapRatesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = ScrapRatesData.all;
    return Scaffold(
      appBar: AppBar(title: const Text('All scrap rates')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final it = items[i];
          final up = it.newPricePerKg >= it.oldPricePerKg;
          final diff = it.newPricePerKg - it.oldPricePerKg;
          final pct =
              it.oldPricePerKg == 0 ? 0 : (diff / it.oldPricePerKg) * 100;
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ScrapDetailPage(item: it))),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFECECEC)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: it.tint.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(it.icon, color: it.tint, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('Old: ₹${it.oldPricePerKg.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12)),
                            const SizedBox(width: 8),
                            Text('Now: ₹${it.newPricePerKg.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    color: Color(0xFF1F8F2E),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Icon(
                          up
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          size: 18,
                          color:
                              up ? const Color(0xFF1F8F2E) : Colors.red),
                      const SizedBox(width: 4),
                      Text('${up ? '+' : ''}${pct.toStringAsFixed(0)}%',
                          style: TextStyle(
                              color: up
                                  ? const Color(0xFF1F8F2E)
                                  : Colors.red,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ScrapDetailPage extends StatelessWidget {
  final ScrapItem item;
  const ScrapDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final up = item.newPricePerKg >= item.oldPricePerKg;
    final diff = item.newPricePerKg - item.oldPricePerKg;
    final pct =
        item.oldPricePerKg == 0 ? 0 : (diff / item.oldPricePerKg) * 100;

    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECECEC)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: item.tint.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.tint, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('₹${item.oldPricePerKg.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.lineThrough)),
                            const SizedBox(width: 8),
                            Text('₹${item.newPricePerKg.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    color: Color(0xFF1F8F2E),
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                          up
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color:
                              up ? const Color(0xFF1F8F2E) : Colors.red),
                      const SizedBox(width: 4),
                      Text('${up ? '+' : ''}${pct.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color:
                                up ? const Color(0xFF1F8F2E) : Colors.red,
                            fontWeight: FontWeight.w800,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // History chart
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECECEC)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price history',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: _LineChart(
                      values: item.history,
                      lineColor: item.tint,
                      fillColor: item.tint.withOpacity(0.15),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.timeline_rounded,
                          size: 16, color: Colors.black54),
                      SizedBox(width: 6),
                      Text('Last 12 periods',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Future potential
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECECEC)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_graph_rounded, color: scheme.primary),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item.futurePotential)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Environmental facts
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECECEC)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.eco_rounded, color: scheme.primary),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item.facts)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  const _LineChart({
    required this.values,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          _LineChartPainter(values: values, lineColor: lineColor, fillColor: fillColor),
      child: Container(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  _LineChartPainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).clamp(1, double.infinity);

    final points = <Offset>[];
    final dx = size.width / (values.length - 1);
    for (var i = 0; i < values.length; i++) {
      final x = i * dx;
      final norm = (values[i] - minV) / range;
      final y = size.height - norm * size.height;
      points.add(Offset(x, y));
    }

    // Fill under curve
    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();
    final fillPaint = Paint()..color = fillColor;
    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // Dots
    final dotPaint = Paint()..color = lineColor;
    for (final p in points) {
      canvas.drawCircle(p, 2.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}
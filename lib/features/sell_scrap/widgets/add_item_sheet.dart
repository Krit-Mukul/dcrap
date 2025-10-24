import 'package:flutter/material.dart';
import '../models/scrap_item.dart';
import 'package:dcrap/core/constants/scrap_rates.dart';

class AddItemSheet extends StatefulWidget {
  final ScrapItem? existing;
  final Function(ScrapItem) onSave;

  const AddItemSheet({super.key, this.existing, required this.onSave});

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  late String type;
  late double weight;
  double? customRate;

  @override
  void initState() {
    super.initState();
    type = widget.existing?.type ?? ScrapRates.ratesPerKg.keys.first;
    weight = widget.existing?.weightKg ?? 1.0;
    customRate = widget.existing?.customRatePerKg;
  }

  @override
  Widget build(BuildContext context) {
    final info = ScrapRates.ratesPerKg[type]!;
    final rate = customRate ?? (info['rate'] as double);

    return SafeArea(
      child: Container(
        height:
            MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.existing == null ? 'Add Item' : 'Edit Item',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Type',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: ScrapRates.ratesPerKg.entries.map((entry) {
                        final selected = entry.key == type;
                        return GestureDetector(
                          onTap: () => setState(() {
                            type = entry.key;
                            customRate = null;
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? (entry.value['color'] as Color).withOpacity(
                                      0.12,
                                    )
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? entry.value['color'] as Color
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  entry.value['icon'] as IconData,
                                  color: selected
                                      ? entry.value['color'] as Color
                                      : Colors.grey.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? entry.value['color'] as Color
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Weight (kg)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(() {
                            weight = (weight - 0.5).clamp(0.5, 999);
                          }),
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.remove),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: (info['color'] as Color).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${weight.toStringAsFixed(1)} kg',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: info['color'] as Color,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            weight = (weight + 0.5).clamp(0.5, 999);
                          }),
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: info['color'] as Color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Slider(
                      value: weight,
                      min: 0.5,
                      max: 50,
                      divisions: 99,
                      activeColor: info['color'] as Color,
                      onChanged: (v) => setState(() => weight = v),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      children: [0.5, 1.0, 2.0, 5.0, 10.0].map((preset) {
                        return OutlinedButton(
                          onPressed: () => setState(() => weight = preset),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          child: Text('${preset}kg'),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rate: ₹${rate.toStringAsFixed(2)}/kg',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total: ₹${(weight * rate).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          if (customRate == null)
                            TextButton(
                              onPressed: () => setState(() {
                                customRate = info['rate'] as double;
                              }),
                              child: const Text('Custom rate'),
                            ),
                        ],
                      ),
                    ),

                    if (customRate != null) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: customRate!.toStringAsFixed(2),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Custom rate per kg',
                          prefixText: '₹',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => customRate = null),
                          ),
                        ),
                        onChanged: (v) {
                          setState(() {
                            customRate = double.tryParse(v) ?? customRate;
                          });
                        },
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final item = ScrapItem(
                      type: type,
                      weightKg: double.parse(weight.toStringAsFixed(1)),
                      customRatePerKg: customRate,
                    );
                    widget.onSave(item);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.existing == null ? 'Add Item' : 'Save Changes',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

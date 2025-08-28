import 'package:flutter/material.dart';

class SellScrapPage extends StatefulWidget {
  const SellScrapPage({super.key});

  @override
  State<SellScrapPage> createState() => _SellScrapPageState();
}

class _SellScrapPageState extends State<SellScrapPage> {
  int _step = 0;

  final List<_ItemLine> _items = [];
  bool _photoAttached = false; // placeholder - integrate image_picker later
  bool _directPickup = false;

  DateTime? _date;
  TimeOfDay? _time;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController(text: 'Thapar University, Patiala');
  final _pincodeCtrl = TextEditingController();

  bool _autoEnabled = false;
  int _autoInterval = 2;
  String _autoUnit = 'Weeks'; // Days | Weeks | Months
  DateTime _autoStart = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  static const Map<String, double> _ratesPerKg = {
    'Newspaper': 12,
    'Cardboard': 10,
    'Plastic': 8,
    'Metal': 25,
    'E-waste': 30,
  };

  double get _estimate {
    return _items.fold(0.0, (sum, e) {
      final rate = _ratesPerKg[e.type] ?? 0;
      return sum + e.weightKg * rate;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Pickup'),
      ),
      body: Stepper(
        currentStep: _step,
        onStepTapped: (i) => setState(() => _step = i),
        onStepContinue: _onNext,
        onStepCancel: _onBack,
        controlsBuilder: (context, details) {
          final isLast = _step == 3;
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(isLast ? 'Book Pickup' : 'Next'),
                ),
                const SizedBox(width: 12),
                if (_step > 0)
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Add Items'),
            isActive: _step >= 0,
            state: _step > 0 ? StepState.complete : StepState.indexed,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_items.isEmpty)
                  Text('No items added yet.', style: TextStyle(color: Colors.grey.shade600)),
                ..._items.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  return Dismissible(
                    key: ValueKey('${item.type}-$i'),
                    background: Container(color: Colors.red.shade100),
                    onDismissed: (_) => setState(() => _items.removeAt(i)),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('${item.type} • ${item.weightKg.toStringAsFixed(1)} kg'),
                      subtitle: Text('Est. ${(item.weightKg * (_ratesPerKg[item.type] ?? 0)).toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openAddItemDialog(existing: item, index: i),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add item'),
                    onPressed: _openAddItemDialog,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Estimated total: ', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('₹ ${_estimate.toStringAsFixed(2)}', style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Photo (optional)'),
            isActive: _step >= 1,
            state: _step > 1 ? StepState.complete : (_photoAttached ? StepState.editing : StepState.indexed),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  value: _photoAttached,
                  onChanged: (v) => setState(() => _photoAttached = v),
                  title: const Text('Attach photo to estimate better'),
                  subtitle: const Text('You can integrate image picker later'),
                ),
                if (_photoAttached)
                  Container(
                    height: 120,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Text('Photo preview placeholder'),
                  ),
              ],
            ),
          ),
          Step(
            title: const Text('Schedule'),
            isActive: _step >= 2,
            state: _step > 2 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                SwitchListTile(
                  value: _directPickup,
                  onChanged: (v) => setState(() => _directPickup = v),
                  title: const Text('Direct pickup (ASAP)'),
                  subtitle: const Text('We will assign the earliest available slot'),
                ),
                if (!_directPickup) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(_date == null
                              ? 'Pick date'
                              : '${_date!.year}-${_pad(_date!.month)}-${_pad(_date!.day)}'),
                          onPressed: _pickDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.schedule),
                          label: Text(_time == null ? 'Pick time' : _time!.format(context)),
                          onPressed: _pickTime,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Step(
            title: const Text('Address & Auto-pickup'),
            isActive: _step >= 3,
            state: StepState.indexed,
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (v) => (v == null || v.trim().length < 8) ? 'Enter valid phone' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressCtrl,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _pincodeCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'PIN code'),
                    validator: (v) => (v == null || v.trim().length < 4) ? 'Enter valid PIN' : null,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: _autoEnabled,
                    onChanged: (v) => setState(() => _autoEnabled = v),
                    title: const Text('Set up automatic pickups'),
                    subtitle: const Text('Repeat at your preferred interval'),
                  ),
                  if (_autoEnabled) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: '$_autoInterval',
                            decoration: const InputDecoration(labelText: 'Every (number)'),
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              final n = int.tryParse(v);
                              if (n != null && n > 0) setState(() => _autoInterval = n);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _autoUnit,
                            items: const [
                              DropdownMenuItem(value: 'Days', child: Text('Days')),
                              DropdownMenuItem(value: 'Weeks', child: Text('Weeks')),
                              DropdownMenuItem(value: 'Months', child: Text('Months')),
                            ],
                            onChanged: (v) => setState(() => _autoUnit = v ?? _autoUnit),
                            decoration: const InputDecoration(labelText: 'Unit'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.event_repeat),
                        label: Text('Start: ${_autoStart.year}-${_pad(_autoStart.month)}-${_pad(_autoStart.day)}'),
                        onPressed: _pickAutoStart,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Summary'),
                    subtitle: Text(
                      [
                        'Items: ${_items.length} • Est. ₹ ${_estimate.toStringAsFixed(2)}',
                        _directPickup
                            ? 'Schedule: ASAP'
                            : 'Schedule: ${_date != null ? '${_date!.year}-${_pad(_date!.month)}-${_pad(_date!.day)}' : '—'} '
                              '${_time != null ? _time!.format(context) : ''}',
                        'Auto: ${_autoEnabled ? 'Every $_autoInterval $_autoUnit' : 'Off'}',
                      ].join('\n'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onNext() async {
    if (_step == 0) {
      if (_items.isEmpty) {
        _snack('Add at least one item');
        return;
      }
    }
    if (_step == 2 && !_directPickup) {
      if (_date == null || _time == null) {
        _snack('Pick date and time or choose direct pickup');
        return;
      }
    }
    if (_step == 3) {
      if (!(_formKey.currentState?.validate() ?? false)) return;
      await _book();
      return;
    }
    setState(() => _step += 1);
  }

  void _onBack() {
    if (_step > 0) setState(() => _step -= 1);
  }

  Future<void> _book() async {
    final bookingId = DateTime.now().millisecondsSinceEpoch.toString();
    final when = _directPickup
        ? 'ASAP'
        : '${_date!.year}-${_pad(_date!.month)}-${_pad(_date!.day)} ${_time!.format(context)}';

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Booking successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 12),
            Text('ID: $bookingId'),
            const SizedBox(height: 6),
            Text('Scheduled: $when'),
            if (_autoEnabled) ...[
              const SizedBox(height: 6),
              Text('Auto: Every $_autoInterval $_autoUnit from '
                  '${_autoStart.year}-${_pad(_autoStart.month)}-${_pad(_autoStart.day)}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );

    if (mounted) Navigator.of(context).pop(); // back to home
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _pickAutoStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _autoStart,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _autoStart = picked);
  }

  void _openAddItemDialog({ _ItemLine? existing, int? index }) {
    String type = existing?.type ?? _ratesPerKg.keys.first;
    double weight = existing?.weightKg ?? 1.0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Add item' : 'Edit item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: type,
              items: _ratesPerKg.keys
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => type = v ?? type,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: weight.toStringAsFixed(1),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                helperText: 'Estimate weight to get a price estimate',
              ),
              onChanged: (v) => weight = double.tryParse(v) ?? weight,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Rate: ₹ ${(_ratesPerKg[type] ?? 0).toStringAsFixed(2)}/kg',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final line = _ItemLine(type: type, weightKg: weight);
              setState(() {
                if (index != null) {
                  _items[index] = line;
                } else {
                  _items.add(line);
                }
              });
              Navigator.pop(context);
            },
            child: Text(existing == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}

class _ItemLine {
  final String type;
  final double weightKg;
  _ItemLine({required this.type, required this.weightKg});
}
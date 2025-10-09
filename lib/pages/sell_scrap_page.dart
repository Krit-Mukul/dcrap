import 'package:flutter/material.dart';
import '../models/scrap_item.dart';
import '../models/saved_address.dart';
import '../models/booking.dart';
import '../constants/scrap_rates.dart';
import '../widgets/sell_scrap/items_step.dart';
import '../widgets/sell_scrap/photo_step.dart';
import '../widgets/sell_scrap/schedule_step.dart';
import '../widgets/sell_scrap/details_step.dart';

class SellScrapPage extends StatefulWidget {
  const SellScrapPage({super.key});

  @override
  State<SellScrapPage> createState() => _SellScrapPageState();
}

class _SellScrapPageState extends State<SellScrapPage> {
  int _step = 0;

  final List<ScrapItem> _items = [];
  bool _photoAttached = false;
  bool _directPickup = true;

  DateTime? _date;
  TimeOfDay? _time;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _autoEnabled = false;
  int _autoInterval = 2;
  String _autoUnit = 'Weeks';

  final _formKey = GlobalKey<FormState>();

  // Saved addresses
  final List<SavedAddress> _savedAddresses = [
    SavedAddress(
      label: 'Home',
      address: 'Thapar University, Patiala',
      pincode: '147004',
    ),
    SavedAddress(
      label: 'Office',
      address: 'Tech Park, Sector 67, Mohali',
      pincode: '160062',
    ),
  ];

  SavedAddress? _selectedAddress;

  double get _estimate {
    return _items.fold(0.0, (sum, item) {
      final rate = item.customRatePerKg ?? ScrapRates.getRateForType(item.type);
      return sum + item.weightKg * rate;
    });
  }

  @override
  void initState() {
    super.initState();
    if (_savedAddresses.isNotEmpty) {
      _selectedAddress = _savedAddresses[0];
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Book Pickup',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: List.generate(4, (i) {
                final active = i == _step;
                final completed = i < _step;
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: completed || active
                                ? colorScheme.primary
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      if (i < 3) const SizedBox(width: 4),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Step content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_step == 0)
                    ItemsStep(
                      items: _items,
                      onAddItem: (item) => setState(() => _items.add(item)),
                      onUpdateItem: (index, item) =>
                          setState(() => _items[index] = item),
                      onRemoveItem: (index) =>
                          setState(() => _items.removeAt(index)),
                      onClearAll: () => setState(() => _items.clear()),
                    ),
                  if (_step == 1)
                    PhotoStep(
                      photoAttached: _photoAttached,
                      onTogglePhoto: () =>
                          setState(() => _photoAttached = !_photoAttached),
                    ),
                  if (_step == 2)
                    ScheduleStep(
                      directPickup: _directPickup,
                      selectedDate: _date,
                      selectedTime: _time,
                      onToggleDirectPickup: () =>
                          setState(() => _directPickup = true),
                      onToggleScheduleLater: () =>
                          setState(() => _directPickup = false),
                      onPickDate: _pickDate,
                      onPickTime: _pickTime,
                    ),
                  if (_step == 3)
                    DetailsStep(
                      formKey: _formKey,
                      nameController: _nameCtrl,
                      phoneController: _phoneCtrl,
                      savedAddresses: _savedAddresses,
                      selectedAddress: _selectedAddress,
                      onAddressSelected: (address) =>
                          setState(() => _selectedAddress = address),
                      onAddAddress: (address) {
                        setState(() {
                          _savedAddresses.add(address);
                          _selectedAddress = address;
                        });
                        _snack('Address added successfully');
                      },
                      autoEnabled: _autoEnabled,
                      autoInterval: _autoInterval,
                      autoUnit: _autoUnit,
                      onAutoToggle: (v) => setState(() => _autoEnabled = v),
                      onConfigureAuto: _showAutoPicker,
                      items: _items,
                      estimate: _estimate,
                    ),
                ],
              ),
            ),
          ),
          // Bottom bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_step > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (_step > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _onNext,
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
                  _step == 3 ? 'Confirm Booking' : 'Continue',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
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
      if (_selectedAddress == null) {
        _snack('Please select a pickup address');
        return;
      }
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
        : '${_date!.day}/${_date!.month}/${_date!.year} ${_time!.format(context)}';

    await showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF10B981),
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Booking ID: #$bookingId',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pickup Time',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          when,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Items',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          '${_items.length}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Est. Amount',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          '₹${_estimate.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _showAutoPicker() async {
    final picked = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) {
        int interval = _autoInterval;
        String unit = _autoUnit;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configure Auto Pickup',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Repeat every',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<int>(
                              value: interval,
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: List.generate(12, (i) => i + 1).map((n) {
                                return DropdownMenuItem(
                                  value: n,
                                  child: Text('$n'),
                                );
                              }).toList(),
                              onChanged: (v) => setDialogState(
                                () => interval = v ?? interval,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              value: unit,
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Days',
                                  child: Text('Days'),
                                ),
                                DropdownMenuItem(
                                  value: 'Weeks',
                                  child: Text('Weeks'),
                                ),
                                DropdownMenuItem(
                                  value: 'Months',
                                  child: Text('Months'),
                                ),
                              ],
                              onChanged: (v) =>
                                  setDialogState(() => unit = v ?? unit),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, {
                              'n': interval,
                              'u': unit,
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    if (picked != null) {
      setState(() {
        _autoInterval = picked['n'] as int;
        _autoUnit = picked['u'] as String;
        _autoEnabled = true;
      });
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

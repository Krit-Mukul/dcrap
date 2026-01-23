import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/scrap_item.dart';
import 'package:dcrap/features/addresses/models/saved_address.dart';
import 'package:dcrap/core/constants/scrap_rates.dart';
import 'package:dcrap/core/services/storage_service.dart';
import 'package:dcrap/core/services/api_service.dart';
import '../widgets/items_step.dart';
import '../widgets/photo_step.dart';
import '../widgets/schedule_step.dart';
import '../widgets/details_step.dart';

class SellScrapPage extends StatefulWidget {
  const SellScrapPage({super.key});

  @override
  State<SellScrapPage> createState() => _SellScrapPageState();
}

class _SellScrapPageState extends State<SellScrapPage> {
  int _step = 0;

  final List<ScrapItem> _items = [];
  final List<XFile> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();
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
                      selectedImages: _selectedImages,
                      onAddPhoto: _pickImages,
                      onRemovePhoto: (index) {
                        setState(() => _selectedImages.removeAt(index));
                      },
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
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Creating your order...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Generate order ID first
      final orderId =
          'ORD${DateTime.now().millisecondsSinceEpoch}${(DateTime.now().millisecond % 1000)}';

      // Upload images to Firebase Storage if any
      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        try {
          imageUrls = await StorageService.uploadOrderImages(
            orderId: orderId,
            images: _selectedImages,
          );
          // print('✅ Uploaded ${imageUrls.length} images');
        } catch (e) {
          // print('⚠️ Image upload failed: $e');
          // Continue without images rather than failing the whole order
        }
      }

      // Calculate total weight and price
      final totalWeight = _items.fold(0.0, (sum, item) => sum + item.weightKg);
      final estimatedPrice = _estimate;

      // Determine scrap type (use first item's type or 'Mixed' if multiple types)
      final scrapType = _items.length == 1 ? _items.first.type : 'Mixed';

      // Create order via API
      final response = await ApiService.createOrder(
        orderId: orderId,
        pickupAddress: _selectedAddress!.address,
        scrapType: scrapType,
        weight: totalWeight,
        estimatedPrice: estimatedPrice,
        customerName: _nameCtrl.text.trim(),
        customerPhone: _phoneCtrl.text.trim(),
        customerNotes:
            'Items: ${_items.map((i) => '${i.type} (${i.weightKg}kg)').join(', ')}',
        imageUrls: imageUrls,
      );

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Extract order data
      final orderData = response['data'];
      final bookingId = orderData['orderId'] ?? orderId;

      final when = _directPickup
          ? 'ASAP'
          : '${_date!.day}/${_date!.month}/${_date!.year} ${_time!.format(context)}';

      // Show success dialog
      await showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      // Close loading dialog if open
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Order Failed'),
            content: Text('Failed to create order: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }

      // print('❌ Order creation error: $e');
    }
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

  Future<void> _pickImages() async {
    if (_selectedImages.length >= 5) {
      _snack('Maximum 5 photos allowed');
      return;
    }

    try {
      // WORKAROUND: Camera crashes on Samsung S23 - gallery only for now
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add Photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CAMERA DISABLED DUE TO CRASHES
              // ListTile(
              //   leading: const Icon(Icons.camera_alt),
              //   title: const Text('Take Photo'),
              //   subtitle: const Text('Currently unavailable'),
              //   enabled: false,
              // ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select existing photos'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Note: Camera temporarily disabled due to device compatibility',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      // Request permissions based on source
      bool permissionGranted = false;

      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        permissionGranted = status.isGranted;

        if (status.isPermanentlyDenied) {
          _showPermissionDialog(
            'Camera Permission Required',
            'Please grant camera permission in app settings to take photos.',
          );
          return;
        }
      } else {
        // For gallery, try multiple permission types
        // On Android 13+, photos permission is needed
        // On older versions, storage permission is needed
        // print('📱 Requesting gallery permissions...');

        PermissionStatus status = await Permission.photos.request();
        // print('📱 Photos permission: $status');

        // If photos permission doesn't work, try storage
        if (status == PermissionStatus.denied ||
            status == PermissionStatus.permanentlyDenied) {
          status = await Permission.storage.request();
          // print('📱 Storage permission: $status');
        }

        // On some devices, we need manageExternalStorage
        if (status == PermissionStatus.denied) {
          status = await Permission.manageExternalStorage.request();
          // print('📱 ManageExternalStorage permission: $status');
        }

        // Limited access is fine for gallery (Android 14+)
        permissionGranted = status.isGranted || status.isLimited;

        if (status.isPermanentlyDenied) {
          _showPermissionDialog(
            'Storage Permission Required',
            'Please grant storage/photos permission in app settings to select images. You may need to enable "Photos and videos" or "Media" access.',
          );
          return;
        }

        // If still denied, try to proceed anyway - picker might work
        if (!permissionGranted) {
          print(
            '⚠️ Permission not explicitly granted, trying picker anyway...',
          );
          permissionGranted = true; // Try anyway
        }
      }

      if (!permissionGranted) {
        _snack(
          'Permission denied. Cannot access ${source == ImageSource.camera ? 'camera' : 'gallery'}',
        );
        return;
      }

      // Pick image with very aggressive optimization to prevent crashes
      // Samsung S23 has 50MP camera which needs heavy compression
      print(
        '📸 Picking image from ${source == ImageSource.camera ? "CAMERA" : "GALLERY"}...',
      );

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: source == ImageSource.camera
            ? 640
            : 1920, // Even smaller: 640x640
        maxHeight: source == ImageSource.camera ? 640 : 1080,
        imageQuality: source == ImageSource.camera
            ? 40
            : 85, // Even lower quality: 40%
        preferredCameraDevice: CameraDevice.rear,
      );

      // print('📸 Image picked: ${image != null ? image.path : "NULL"}');

      // Add small delay after camera capture to let system stabilize
      if (source == ImageSource.camera && image != null) {
        // print('⏱️ Waiting for system to stabilize...');
        await Future.delayed(const Duration(milliseconds: 500));
        // print('✅ System stabilized');
      }

      if (image != null) {
        if (mounted) {
          setState(() {
            _selectedImages.add(image);
          });

          // Log size asynchronously without blocking UI
          _logImageSize(image);

          _snack('Photo added successfully');
        }
      }
    } catch (e, stackTrace) {
      // print('❌ Error picking image: $e');
      // print('Stack trace: $stackTrace');
      if (mounted) {
        _snack('Failed to pick image. Error: ${e.toString().substring(0, 50)}');
      }
    }
  }

  // Log image size asynchronously to avoid blocking UI
  void _logImageSize(XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      final sizeInMB = bytes.length / (1024 * 1024);
      // print('✅ Image captured: ${sizeInMB.toStringAsFixed(2)} MB');

      if (sizeInMB > 2.0) {
        print(
          '⚠️ WARNING: Image is ${sizeInMB.toStringAsFixed(2)} MB - may cause issues',
        );
      }
    } catch (e) {
      // print('Failed to read image size: $e');
    }
  }

  void _showPermissionDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
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

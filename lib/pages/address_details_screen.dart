import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/address_provider.dart';

class AddressDetailsScreen extends ConsumerStatefulWidget {
  final String currentLocation;

  const AddressDetailsScreen({super.key, required this.currentLocation});

  @override
  ConsumerState<AddressDetailsScreen> createState() =>
      _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends ConsumerState<AddressDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _customTagController = TextEditingController();
  String _selectedTag = 'Home';

  @override
  void dispose() {
    _houseController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _customTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withAlpha(230),
                      Theme.of(context).colorScheme.primary.withAlpha(180),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 20, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Add Address Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Help us deliver to the right place',
                          style: TextStyle(
                            color: Colors.white.withAlpha(204),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Current Location Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detected Location',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.currentLocation,
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Address Details Section
                    _buildSectionHeader(
                      icon: Icons.home_rounded,
                      title: 'Address Details',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _houseController,
                      label: 'House/Flat No.',
                      hint: 'e.g., Flat 101, Building A',
                      icon: Icons.apartment_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your house/flat number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _streetController,
                      label: 'Street Address',
                      hint: 'e.g., MG Road',
                      icon: Icons.signpost_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your street address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _cityController,
                            label: 'City',
                            hint: 'e.g., Mumbai',
                            icon: Icons.location_city_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _stateController,
                            label: 'State',
                            hint: 'e.g., Maharashtra',
                            icon: Icons.map_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _pinCodeController,
                      label: 'PIN Code',
                      hint: 'e.g., 400001',
                      icon: Icons.push_pin_rounded,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter PIN code';
                        }
                        if (value.length != 6) {
                          return 'PIN code must be 6 digits';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Tag Selection Section
                    _buildSectionHeader(
                      icon: Icons.label_rounded,
                      title: 'Save Address As',
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTagOption(
                            icon: Icons.home_rounded,
                            label: 'Home',
                            isSelected: _selectedTag == 'Home',
                            color: const Color(0xFF10B981),
                            onTap: () {
                              setState(() => _selectedTag = 'Home');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTagOption(
                            icon: Icons.work_rounded,
                            label: 'Work',
                            isSelected: _selectedTag == 'Work',
                            color: const Color(0xFF3B82F6),
                            onTap: () {
                              setState(() => _selectedTag = 'Work');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTagOption(
                            icon: Icons.edit_rounded,
                            label: 'Custom',
                            isSelected: _selectedTag == 'Custom',
                            color: const Color(0xFF8B5CF6),
                            onTap: () {
                              setState(() => _selectedTag = 'Custom');
                            },
                          ),
                        ),
                      ],
                    ),

                    if (_selectedTag == 'Custom') ...[
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _customTagController,
                        label: 'Custom Tag Name',
                        hint: 'e.g., Parents House, Friend\'s Place',
                        icon: Icons.label_outline_rounded,
                        validator: (value) {
                          if (_selectedTag == 'Custom' &&
                              (value == null || value.isEmpty)) {
                            return 'Please enter a custom tag name';
                          }
                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Save Button
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(204),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(51),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _saveAddressDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Save Address',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: Colors.grey.shade600),
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: maxLength != null ? '' : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFECECEC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFECECEC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildTagOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [color.withAlpha(230), color.withAlpha(180)],
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFECECEC),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withAlpha(51),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withAlpha(51)
                    : color.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAddressDetails() {
    if (_formKey.currentState!.validate()) {
      final tag = _selectedTag == 'Custom'
          ? _customTagController.text
          : _selectedTag;

      final address = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        label: tag,
        line1: _houseController.text.trim(),
        line2: _streetController.text.trim(),
        city: _cityController.text.trim(),
        pinCode: _pinCodeController.text.trim(),
      );

      ref.read(addressesProvider.notifier).add(address);

      final listLen = ref.read(addressesProvider).length;
      ref.read(selectedAddressIndexProvider.notifier).state = listLen - 1;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Address saved successfully!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );

      Navigator.of(context).pop();
    }
  }
}

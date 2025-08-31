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
  final TextEditingController _customTagController = TextEditingController();
  String _selectedTag = 'Home'; // Default tag

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Address Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Current Location: ${widget.currentLocation}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _houseController,
                  decoration: const InputDecoration(
                    labelText: 'House/Flat No.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your house/flat number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(
                    labelText: 'Street Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your street address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tag:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Home',
                          groupValue: _selectedTag,
                          onChanged: (value) {
                            setState(() {
                              _selectedTag = value!;
                            });
                          },
                        ),
                        const Text('Home', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Work',
                          groupValue: _selectedTag,
                          onChanged: (value) {
                            setState(() {
                              _selectedTag = value!;
                            });
                          },
                        ),
                        const Text('Work', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Custom',
                          groupValue: _selectedTag,
                          onChanged: (value) {
                            setState(() {
                              _selectedTag = value!;
                            });
                          },
                        ),
                        const Text('Custom', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                if (_selectedTag == 'Custom') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _customTagController,
                    decoration: const InputDecoration(
                      labelText: 'Custom Tag Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (_selectedTag == 'Custom' &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter a custom tag name';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveAddressDetails,
                  child: const Text('Save Address'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveAddressDetails() {
    if (_formKey.currentState!.validate()) {
      final tag = _selectedTag == 'Custom'
          ? _customTagController.text
          : _selectedTag;

      final address = {
        'tag': tag,
        'house': _houseController.text,
        'street': _streetController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'location': widget.currentLocation,
      };

      // Save the address using the provider
      ref.read(savedAddressesProvider.notifier).addAddress(address);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Address saved successfully!')),
        );

      Navigator.of(context).pop(); // Go back to the previous screen
    }
  }
}

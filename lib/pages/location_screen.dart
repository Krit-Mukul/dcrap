import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _addressController = TextEditingController();
  final Location _location = Location();

  bool _isFetchingLocation = false;
  String? _currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Address'),
        // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add Lottie animation above the button
            SizedBox(height: 120),
            Center(
              child: SizedBox(
                height: 200, // Adjust the height as needed
                child: Lottie.asset(
                  'assets/delivery_animation.json', // Replace with your animation file path
                  repeat: true,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isFetchingLocation ? null : _getCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: _isFetchingLocation
                  ? const Text('Fetching Location...')
                  : const Text('Use Current Location'),
            ),
            if (_currentLocation != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Current Location:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_currentLocation!),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: _saveAddress,
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      // Check location permission
      final permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        final requestPermission = await _location.requestPermission();
        if (requestPermission != PermissionStatus.granted) {
          setState(() {
            _isFetchingLocation = false;
          });
          return;
        }
      }

      // Check if location service is enabled
      final serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        final requestService = await _location.requestService();
        if (!requestService) {
          setState(() {
            _isFetchingLocation = false;
          });
          return;
        }
      }

      // Get current location
      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation =
            'Lat: ${locationData.latitude}, Lng: ${locationData.longitude}';
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar() // Clear the previous SnackBar
        ..showSnackBar(SnackBar(content: Text('Failed to fetch location: $e')));
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  void _saveAddress() {
    final address = _addressController.text.isNotEmpty
        ? _addressController.text
        : _currentLocation;

    if (address == null || address.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar() // Clear the previous SnackBar
        ..showSnackBar(
          const SnackBar(content: Text('Please enter or fetch your address')),
        );
      return;
    }

    // Save the address (e.g., send it to the server or save locally)
    print('Address saved: $address');
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // Clear the previous SnackBar
      ..showSnackBar(
        const SnackBar(content: Text('Address saved successfully!')),
      );
  }
}

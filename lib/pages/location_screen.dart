import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'address_details_screen.dart'; // Import the new screen

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Location _location = Location();

  bool _isFetchingLocation = false;
  String? _currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Your Address')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  'assets/delivery_animation.json',
                  repeat: true,
                ),
              ),

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
            ],
          ),
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

      Navigator.of(context).pop();
      // Navigate to the AddressDetailsScreen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              AddressDetailsScreen(currentLocation: _currentLocation!),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Failed to fetch location: $e')));
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }
}

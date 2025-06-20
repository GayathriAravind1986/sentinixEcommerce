import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _pickedLocation;

  final LatLng _initialPosition = const LatLng(12.9716, 77.5946); // default

  void _onTap(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  void _onConfirm() {
    if (_pickedLocation != null) {
      Navigator.of(context).pop(_pickedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick a location")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onTap,
            markers: _pickedLocation == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId("picked"),
                      position: _pickedLocation!,
                    ),
                  },
          ),
          if (_pickedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _onConfirm,
                child: const Text("Confirm Location"),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _pickedLocation;
  String? _pickedAddress;

  final LatLng _initialPosition = const LatLng(12.9716, 77.5946); // Bangalore

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _onTap(LatLng position) async {
    setState(() {
      _pickedLocation = position;
      _pickedAddress = null; // Reset address
    });

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _pickedAddress = [
            if (place.name != null && place.name!.isNotEmpty) place.name,
            if (place.street != null && place.street!.isNotEmpty) place.street,
            if (place.locality != null && place.locality!.isNotEmpty) place.locality,
            if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) place.administrativeArea,
          ].whereType<String>().join(", ");
        });
      }
    } catch (e) {
      setState(() {
        _pickedAddress = "Address not found";
      });
    }
  }

  void _onConfirm() {
    if (_pickedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location")),
      );
      return;
    }

    Navigator.pop(context, _pickedAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        backgroundColor: appPrimaryColor,
        foregroundColor: whiteColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              // You can implement current location fetch here
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14,
            ),
            onMapCreated: _onMapCreated,
            onTap: _onTap,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _pickedLocation == null
                ? {}
                : {
              Marker(
                markerId: const MarkerId("picked"),
                position: _pickedLocation!,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            },
          ),
          if (_pickedAddress != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4)
                  ],
                ),
                child: Text(
                  _pickedAddress!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: appPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("CONFIRM LOCATION", style: TextStyle(color: whiteColor)),
            ),
          ),
        ],
      ),
    );
  }
}

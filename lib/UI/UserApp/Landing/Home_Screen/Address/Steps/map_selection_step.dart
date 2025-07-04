import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Address/Steps/address_details_step.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Address/Steps/address_selection_step.dart';

class MapSelectionStep extends StatefulWidget {
  final dynamic fromTo;
  const MapSelectionStep({super.key, this.fromTo});

  @override
  State<MapSelectionStep> createState() => _MapSelectionStepState();
}

class _MapSelectionStepState extends State<MapSelectionStep> {
  GoogleMapController? _mapController;
  LatLng defaultPosition = const LatLng(8.7139, 77.7567);
  LatLng? selectedPosition;
  String selectedAddress = '';
  String selectedPinCode = '';
  String? area;
  String? city;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => AddressSelectionStep(
                    fromTo: widget.fromTo,
                  )),
        );
        return false; // prevent default back behavior
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: appPrimaryColor,
              title: Text("Select Location",
                  style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600)),
              centerTitle: true,
              leading: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddressSelectionStep(
                              fromTo: widget.fromTo,
                            )),
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: whiteColor,
                    )),
              ),
            ),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(8.7139, 77.7567),
                  zoom: 15,
                ),
                onMapCreated: (controller) => _mapController = controller,
                onTap: (LatLng location) async {
                  try {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      location.latitude,
                      location.longitude,
                    );

                    String displayAddress = "";
                    String pincode = "";

                    if (placemarks.isNotEmpty) {
                      final place = placemarks.first;
                      area = place.subLocality;
                      city = place.locality;
                      displayAddress = [
                        place.street,
                        place.subLocality,
                        place.locality
                      ].where((e) => e != null && e.isNotEmpty).join(", ");

                      pincode = place.postalCode ?? "";
                    }

                    setState(() {
                      selectedPosition = location;
                      selectedAddress = displayAddress;
                      selectedPinCode = pincode;
                    });
                  } catch (e) {
                    print("Error getting address: $e");
                  }
                },
                markers: {
                  Marker(
                    markerId: const MarkerId("selected_location"),
                    position: selectedPosition ?? defaultPosition,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                  ),
                },
              ),
              Positioned(
                right: 16,
                bottom: 250,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: "zoom_in",
                      onPressed: () => _mapController?.animateCamera(
                        CameraUpdate.zoomIn(),
                      ),
                      backgroundColor: whiteColor,
                      child: const Icon(Icons.add, color: appPrimaryColor),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: "zoom_out",
                      onPressed: () => _mapController?.animateCamera(
                        CameraUpdate.zoomOut(),
                      ),
                      backgroundColor: whiteColor,
                      child: const Icon(Icons.remove, color: appPrimaryColor),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedAddress.isNotEmpty
                            ? selectedAddress
                            : 'Select a location on map',
                        style: MyTextStyle.f16(textColorDark),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedPinCode.isNotEmpty ? selectedPinCode : '',
                        style: MyTextStyle.f14(greyColor),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            debugPrint("pincode:$selectedPinCode");
                            debugPrint("address:$selectedAddress");
                            debugPrint("position:$selectedPosition");
                            debugPrint(
                                "latitude:${selectedPosition?.latitude}");
                            debugPrint(
                                "longitude:${selectedPosition?.longitude}");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AddressDetailsStep(
                                        from: widget.fromTo,
                                        pinCode: selectedPinCode,
                                        address: selectedAddress,
                                        lat: selectedPosition?.latitude ?? 0.0,
                                        lon: selectedPosition?.longitude ?? 0.0,
                                        area: area,
                                        city: city,
                                      )),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            "Confirm Location",
                            style: MyTextStyle.f16(whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

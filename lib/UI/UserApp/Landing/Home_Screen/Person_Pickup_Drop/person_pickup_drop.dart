import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/customTextfield.dart';
import 'package:sentinix_ecommerce/Reusable/alternative_number.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Address/Steps/address_selection_step.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Navigation_Bar/Navigation_bar.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildBannerSlider.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildLocationFileds.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildMediaPreview.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildPaymentMethodOptionDialog.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildVehicleOption.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildPaymentRow.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildSubmitButton.dart';
import 'package:sentinix_ecommerce/Reusable/customdropfield.dart';
import 'package:sentinix_ecommerce/Reusable/chosen_vehicles.dart';

class PersonPickupDropScreen extends StatelessWidget {
  const PersonPickupDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const PersonPickupDropView(),
    );
  }
}

class PersonPickupDropView extends StatefulWidget {
  const PersonPickupDropView({super.key});

  @override
  State<PersonPickupDropView> createState() => _PersonPickupDropViewState();
}

class _PersonPickupDropViewState extends State<PersonPickupDropView> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int currentPage = 0;
  String _selectedPaymentMethod = 'COD';
  String? _selectedVehicle;
  Timer? _autoSlideTimer;
  final _pickupControllers = [TextEditingController()];
  final _dropControllers = [TextEditingController()];
  final _packageController = TextEditingController();
  final _instructionController = TextEditingController();
  final _altPhoneController = TextEditingController();

  final List<File> _mediaFiles = [];
  final List<File> _videoFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isShowingImages = true;
  List<LatLng?> pickupCoordinates = [];
  List<LatLng?> dropCoordinates = [];
  double totalKm = 0.0;
  final List<String> _banners = [
    'assets/image/banner_1.png',
    'assets/image/banner_2.jpg',
    'assets/image/banner_3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlider();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    _packageController.dispose();
    _instructionController.dispose();
    _altPhoneController.dispose();
    for (var c in _pickupControllers) {
      c.dispose();
    }
    for (var c in _dropControllers) {
      c.dispose();
    }
    super.dispose();
  }

  double calculateDistanceInKm(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;

    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  List<Map<String, double>> convertLatLngListToMapList(List<LatLng> locations) {
    return locations
        .map((latLng) => {
              'lat': latLng.latitude,
              'lon': latLng.longitude,
            })
        .toList();
  }

  double calculateTotalDistance(
      List<Map<String, double>> pickups, List<Map<String, double>> drops) {
    double totalDistance = 0.0;

    // Distance between pickups
    for (int i = 0; i < pickups.length - 1; i++) {
      totalDistance += calculateDistanceInKm(
        pickups[i]['lat']!,
        pickups[i]['lng']!,
        pickups[i + 1]['lat']!,
        pickups[i + 1]['lng']!,
      );
    }

    // Pickup to first drop
    if (pickups.isNotEmpty && drops.isNotEmpty) {
      totalDistance += calculateDistanceInKm(
        pickups.last['lat']!,
        pickups.last['lng']!,
        drops.first['lat']!,
        drops.first['lng']!,
      );
    }

    // Distance between drops
    for (int i = 0; i < drops.length - 1; i++) {
      totalDistance += calculateDistanceInKm(
        drops[i]['lat']!,
        drops[i]['lng']!,
        drops[i + 1]['lat']!,
        drops[i + 1]['lng']!,
      );
    }

    return totalDistance;
  }

  Future<void> selectAddress(bool isPickup, int index) async {
    final selectedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressSelectionStep(fromTo: "ride"),
      ),
    );

    if (selectedAddress != null && mounted) {
      debugPrint("Selected Address: $selectedAddress");

      final lat = selectedAddress.latitude;
      final lon = selectedAddress.longtitude;
      debugPrint("Selected LatLng: ($lat, $lon)");

      // Format address
      String formattedAddress = [
        if (selectedAddress.flatAddress?.isNotEmpty ?? false)
          'House No: ${selectedAddress.flatAddress}',
        if (selectedAddress.floorNumber != null)
          'Floor No: ${selectedAddress.floorNumber}',
        if (selectedAddress.apartmentName?.isNotEmpty ?? false)
          selectedAddress.apartmentName,
        if (selectedAddress.streetName?.isNotEmpty ?? false)
          selectedAddress.streetName,
        if (selectedAddress.areaName?.isNotEmpty ?? false)
          selectedAddress.areaName,
        if (selectedAddress.maplocation?.isNotEmpty ?? false)
          selectedAddress.maplocation,
        if ((selectedAddress.pinCode?.toString().isNotEmpty ?? false))
          selectedAddress.pinCode,
      ]
          .where((part) => part != null && part.toString().trim().isNotEmpty)
          .join(', ');

      setState(() {
        if (isPickup) {
          _pickupControllers[index].text = formattedAddress;

          // Store coordinates
          if (pickupCoordinates.length > index) {
            pickupCoordinates[index] =
                LatLng(selectedAddress.latitude, selectedAddress.longtitude);
            debugPrint("pickUpCoordinate:$pickupCoordinates");
          } else {
            pickupCoordinates.add(
                LatLng(selectedAddress.latitude, selectedAddress.longtitude));
            debugPrint("pickupCoordinates:$pickupCoordinates");
          }

          debugPrint("pickUp:${_pickupControllers[index].text}");
        } else {
          _dropControllers[index].text = formattedAddress;

          if (dropCoordinates.length > index) {
            dropCoordinates[index] =
                LatLng(selectedAddress.latitude, selectedAddress.longtitude);
            debugPrint("dropCoordinates:$dropCoordinates");
          } else {
            dropCoordinates.add(
                LatLng(selectedAddress.latitude, selectedAddress.longtitude));
            debugPrint("dropCoordinates:$dropCoordinates");
          }

          debugPrint("drop:${_dropControllers[index].text}");
        }
      });
    }
  }

  void _startAutoSlider() {
    _autoSlideTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!mounted || !_pageController.hasClients) return;

      setState(() {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      });
    });
  }

  Future<void> _pickMedia(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null && _mediaFiles.length < 3 && mounted) {
        setState(() => _mediaFiles.add(File(pickedFile.path)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
        );
      }
    }
  }

  void _removeMedia(int index) {
    if (mounted) setState(() => _mediaFiles.removeAt(index));
  }

  Future<void> _pickVideo(ImageSource source) async {
    if (_videoFiles.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can select up to 3 videos only")),
      );
      return;
    }

    final pickedFile = await _picker.pickVideo(source: source);

    if (pickedFile != null) {
      setState(() {
        _videoFiles.add(File(pickedFile.path));
        debugPrint("Picked video: ${pickedFile.path}");
      });
    }
  }

  void _removeVideo(int index) {
    setState(() {
      _videoFiles.removeAt(index);
    });
  }

  void _showMediaVideoPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: appPrimaryColor),
            title: const Text("Image"),
            onTap: () {
              Navigator.pop(ctx);
              _isShowingImages = true;
              _showMediaPicker();
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_camera_back_outlined,
                color: appPrimaryColor),
            title: const Text("Video"),
            onTap: () {
              Navigator.pop(ctx);
              _isShowingImages = false;
              _showVideoPicker();
            },
          )
        ],
      ),
    );
  }

  void _showMediaPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: appPrimaryColor),
            title: const Text("Camera"),
            onTap: () {
              Navigator.pop(ctx);
              _pickMedia(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: appPrimaryColor),
            title: const Text("Gallery"),
            onTap: () {
              Navigator.pop(ctx);
              _pickMedia(ImageSource.gallery);
            },
          )
        ],
      ),
    );
  }

  void _showVideoPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.videocam, color: appPrimaryColor),
            title: const Text("Camera"),
            onTap: () {
              Navigator.pop(ctx);
              _pickVideo(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library, color: appPrimaryColor),
            title: const Text("Gallery"),
            onTap: () {
              Navigator.pop(ctx);
              _pickVideo(ImageSource.gallery);
            },
          )
        ],
      ),
    );
  }

  void _showVehicleSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Vehicle",
                style: MyTextStyle.f16(blackColor, weight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  VehicleOptionTile(
                    icon: Icons.electric_bike,
                    name: "Bike",
                    selected: _selectedVehicle == "Bike",
                    onTap: () {
                      setState(() => _selectedVehicle = "Bike");
                      Navigator.pop(context);
                      _showPaymentMethodSelection();
                    },
                    color: appPrimaryColor,
                  ),
                  const SizedBox(height: 8),
                  VehicleOptionTile(
                    icon: Icons.directions_car,
                    name: "Car",
                    selected: _selectedVehicle == "Car",
                    onTap: () {
                      setState(() => _selectedVehicle = "Car");
                      Navigator.pop(context);
                      _showPaymentMethodSelection();
                    },
                    color: appPrimaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentMethodSelection() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Payment Method",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              PaymentMethodOption(
                method: "Online",
                icon: Icons.credit_card,
                onTap: () {
                  setState(() => _selectedPaymentMethod = "Online");
                  Navigator.pop(context);
                  _showPaymentSummary();
                },
              ),
              const SizedBox(height: 8),
              PaymentMethodOption(
                method: "COD",
                icon: Icons.money,
                onTap: () {
                  setState(() => _selectedPaymentMethod = "COD");
                  Navigator.pop(context);
                  _showPaymentSummary();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Payment Summary"),
            backgroundColor: appPrimaryColor,
            foregroundColor: whiteColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vehicle: $_selectedVehicle",
                  style: MyTextStyle.f18(blackColor, weight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("# Total 3.14 km",
                    style:
                        MyTextStyle.f18(blackColor, weight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text("Payment Details",
                    style:
                        MyTextStyle.f16(blackColor, weight: FontWeight.bold)),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaymentRow(
                      label: "Base Fare",
                      amount: _selectedVehicle == "Bike" ? "₹20.00" : "₹40.00",
                      icon: Icons.price_change,
                    ),
                    PaymentRow(
                      label: "Distance Charge",
                      amount: _selectedVehicle == "Bike" ? "₹19.00" : "₹39.00",
                      icon: Icons.directions,
                    ),
                    PaymentRow(
                      label: "Additional 0.1 km",
                      amount: _selectedVehicle == "Bike" ? "₹1.40" : "₹2.80",
                      icon: Icons.add_road,
                    ),
                    PaymentRow(
                      label: "To Pay",
                      amount: _selectedVehicle == "Bike" ? "₹40.40" : "₹81.80",
                      isTotal: true,
                      icon: Icons.payments,
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Place Order",
                        style: TextStyle(color: whiteColor, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirm Order",
            style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Are you sure you want to place this order?"),
            const SizedBox(height: 16),
            Text("Vehicle: $_selectedVehicle"),
            Text("Payment Method: $_selectedPaymentMethod"),
            const SizedBox(height: 16),
            Text("Total Amount:",
                style: MyTextStyle.f16(blackColor, weight: FontWeight.bold)),
            Text(_selectedVehicle == "Bike" ? "₹40.40" : "₹81.80",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCEL", style: TextStyle(color: redColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: appPrimaryColor),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashBoardScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Order placed successfully!"),
                  backgroundColor: appPrimaryColor,
                ),
              );
            },
            child: const Text("CONFIRM", style: TextStyle(color: whiteColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (pickupCoordinates.isNotEmpty && dropCoordinates.isNotEmpty) {
      List<Map<String, double>> pickupPoints = pickupCoordinates
          .whereType<LatLng>()
          .map((e) =>
              {'lat': e.latitude, 'lng': e.longitude}) // 'lng', not 'lon'
          .toList();

      List<Map<String, double>> dropPoints = dropCoordinates
          .whereType<LatLng>()
          .map((e) => {'lat': e.latitude, 'lng': e.longitude})
          .toList();
      totalKm = calculateTotalDistance(pickupPoints, dropPoints);
      debugPrint("totalKm:${totalKm.toStringAsFixed(2)}");
    }
    Widget mainContainer() {
      const EdgeInsetsGeometry fieldHorizontalPadding = EdgeInsets.symmetric(
          horizontal: 8.0); // Example: adjust as needed for text fields

      // const EdgeInsetsGeometry micHorizontalPadding = EdgeInsets.symmetric(
      //     horizontal: 0.0); // Example: adjust as needed for mic box

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              BannerSlider(banners: _banners),
              const SizedBox(height: 24),
              Padding(
                padding: fieldHorizontalPadding,
                child: LocationFields(
                  label: "Pickup Location",
                  controllers: _pickupControllers,
                  showAddRemove: true,
                  onAdd: () {
                    if (_pickupControllers.length < 4) {
                      setState(() =>
                          _pickupControllers.add(TextEditingController()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Maximum 4 pickup locations allowed")),
                      );
                    }
                  },
                  onRemove: () {
                    if (_pickupControllers.length > 1) {
                      setState(() {
                        _pickupControllers.removeLast();

                        // Remove the last pickup coordinate safely
                        if (pickupCoordinates.isNotEmpty) {
                          pickupCoordinates.removeLast();
                          debugPrint("pickupCoorremove:$pickupCoordinates");
                        }

                        // Recalculate totalKm if both lists are still valid
                        if (pickupCoordinates.isNotEmpty &&
                            dropCoordinates.isNotEmpty) {
                          List<Map<String, double>> pickupPoints =
                              pickupCoordinates
                                  .whereType<LatLng>()
                                  .map((e) => {
                                        'lat': e.latitude,
                                        'lng': e.longitude,
                                      })
                                  .toList();

                          List<Map<String, double>> dropPoints = dropCoordinates
                              .whereType<LatLng>()
                              .map((e) => {
                                    'lat': e.latitude,
                                    'lng': e.longitude,
                                  })
                              .toList();

                          totalKm =
                              calculateTotalDistance(pickupPoints, dropPoints);
                          debugPrint("totalKm: ${totalKm.toStringAsFixed(2)}");
                        } else {
                          totalKm = 0.0;
                        }
                      });
                    }
                  },
                  onTap: (index) => selectAddress(true, index),
                ),
              ),

              const SizedBox(height: 12),
              Padding(
                padding: fieldHorizontalPadding,
                child: LocationFields(
                  label: "Drop Location",
                  controllers: _dropControllers,
                  showAddRemove: true,
                  onAdd: () {
                    if (_dropControllers.length < 4) {
                      setState(
                          () => _dropControllers.add(TextEditingController()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Maximum 4 pickup locations allowed")),
                      );
                    }
                  },
                  onRemove: () {
                    if (_dropControllers.length > 1) {
                      setState(() {
                        _dropControllers.removeLast();

                        // Remove the last drop coordinate
                        if (dropCoordinates.isNotEmpty) {
                          dropCoordinates.removeLast();
                          debugPrint("dropCoorremove:$dropCoordinates");
                        }

                        // Recalculate totalKm if both lists are not empty
                        if (pickupCoordinates.isNotEmpty &&
                            dropCoordinates.isNotEmpty) {
                          List<Map<String, double>> pickupPoints =
                              pickupCoordinates
                                  .whereType<LatLng>()
                                  .map((e) => {
                                        'lat': e.latitude,
                                        'lng': e.longitude,
                                      })
                                  .toList();

                          List<Map<String, double>> dropPoints = dropCoordinates
                              .whereType<LatLng>()
                              .map((e) => {
                                    'lat': e.latitude,
                                    'lng': e.longitude,
                                  })
                              .toList();

                          totalKm =
                              calculateTotalDistance(pickupPoints, dropPoints);
                          debugPrint("totalKm: $totalKm");
                        } else {
                          totalKm = 0.0;
                        }
                      });
                    }
                  },
                  onTap: (index) => selectAddress(false, index),
                ),
              ),
              const SizedBox(height: 12),
              Text("Maximum 4 pickup locations allowed"),
              Padding(
                padding: fieldHorizontalPadding,
                child: CustomTextField(
                  hint: "Package Details",
                  controller: _packageController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "Enter package details"
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: fieldHorizontalPadding,
                child: CustomTextField(
                  hint: "Special Instructions (Optional)",
                  controller: _instructionController,
                  maxLength: 200,
                  validator: (val) => null, // Optional field
                ),
              ),
              // const SizedBox(height: 12),
              // Padding(
              //   //padding: micHorizontalPadding, // <<< UNIQUE PADDING HERE
              //   padding: EdgeInsets.only(
              //       left: 15, right: 15), // <<< UNIQUE PADDING HERE
              //   child: VoiceRecorderBox(),
              // ),

              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: AlternativePhoneField(
                  controller: _altPhoneController,
                  onPhoneChanged: (val) {
                    debugPrint("Alt Phone: $val");
                  },
                ),
              ),
              //vehicle
              const SizedBox(height: 12),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomDropdownField<String>(
                    hint: "Select Vehicle",
                    value: _selectedVehicle,
                    items: ["Bike", "Car", "Auto"]
                        .map((v) => DropdownMenuItem(
                            value: v,
                            child: Text(
                              v,
                              style: MyTextStyle.f16(appPrimaryColor),
                            )))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedVehicle = val);
                    },
                    validator: (val) =>
                        val == null ? 'Please select a vehicle' : null,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: MediaPreviewWidget(
                  mediaFiles: _isShowingImages ? _mediaFiles : _videoFiles,
                  onAddMedia: _showMediaVideoPicker,
                  onRemoveMedia: (index) => _isShowingImages
                      ? _removeMedia(index)
                      : _removeVideo(index),
                ),
              ),
              if (_selectedVehicle != null) ...[
                ChosenVehicleInfo(
                  selectedVehicle: _selectedVehicle!,
                  totalKm: totalKm.round().toDouble(),
                  totalMinutes: (totalKm / 0.5).round(),
                ),
              ],
              const SizedBox(height: 24),
              SubmitButton(
                formKey: _formKey,
                onValid: _showVehicleSelectionDialog,
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: appPrimaryColor,
            title: Text("Book Ride",
                style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600)),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashBoardScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Icon(Icons.arrow_back_ios_new_outlined, color: whiteColor),
              ),
            ),
          ),
        ),
        body: BlocBuilder<DemoBloc, dynamic>(
          builder: (context, state) {
            return mainContainer();
          },
        ),
      ),
    );
  }
}

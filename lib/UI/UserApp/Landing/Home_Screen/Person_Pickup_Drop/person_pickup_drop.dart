import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/VoiceRecorder.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Navigation_Bar/Navigation_bar.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildBannerSlider.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildLocationFileds.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildMediaPreview.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildPaymentMethodOptionDialog.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildVehicleOption.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildPaymentRow.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/buildSubmitButton.dart';

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
  int _currentPage = 0;
  int _pickupType = 0;
  String _selectedPaymentMethod = 'COD';
  String? _selectedVehicle;
  late Timer _timer;

  final _pickupControllers = [TextEditingController()];
  final _dropControllers = [TextEditingController()];
  final _packageController = TextEditingController();
  final _instructionController = TextEditingController();
  final _altPhoneController = TextEditingController();

  final List<File> _mediaFiles = [];
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
    _timer.cancel();
    _pageController.dispose();
    _packageController.dispose();
    _instructionController.dispose();
    _altPhoneController.dispose();
    for (var c in _pickupControllers) c.dispose();
    for (var c in _dropControllers) c.dispose();
    super.dispose();
  }

  void _startAutoSlider() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentPage = (_currentPage + 1) % _banners.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Only numbers are allowed';
    if (value.length != 10) return 'Enter 10-digit number';
    return null;
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
              const Text("Select Vehicle", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              const Text("Select Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
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
                Text("Vehicle: $_selectedVehicle", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("# Total 3.14 km", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text("Payment Details", style: TextStyle(fontWeight: FontWeight.bold)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Place Order", style: TextStyle(color: whiteColor, fontSize: 16)),
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
        title: const Text("Confirm Order", style: TextStyle(color: appPrimaryColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Are you sure you want to place this order?"),
            const SizedBox(height: 16),
            Text("Vehicle: $_selectedVehicle"),
            Text("Payment Method: $_selectedPaymentMethod"),
            const SizedBox(height: 16),
            const Text("Total Amount:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_selectedVehicle == "Bike" ? "₹40.40" : "₹81.80", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    Widget mainContainer() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              BannerSlider(banners: _banners),
              const SizedBox(height: 24),
              ToggleButtons(
                isSelected: [_pickupType == 0, _pickupType == 1],
                onPressed: (index) => setState(() => _pickupType = index),
                borderRadius: BorderRadius.circular(8),
                selectedColor: whiteColor,
                fillColor: appPrimaryColor,
                color: appPrimaryColor,
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Single")),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Multi Pickup")),
                ],
              ),
              const SizedBox(height: 24),
              if (_pickupType == 1)
                LocationFields(
                  label: "Pickup Location",
                  controllers: _pickupControllers,
                  showAddRemove: true,
                  onAdd: () {
                    if (_pickupControllers.length < 4) {
                      setState(() => _pickupControllers.add(TextEditingController()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Maximum 4 pickup locations allowed")),
                      );
                    }
                  },
                  onRemove: () {
                    if (_pickupControllers.length > 1) {
                      setState(() => _pickupControllers.removeLast());
                    }
                  },
                )
              else
                LocationFields(
                  label: "Pickup Location",
                  controllers: [_pickupControllers[0]],
                  showAddRemove: false,
                  onAdd: () {},
                  onRemove: () {},
                ),
              const SizedBox(height: 12),
              LocationFields(
                label: "Drop Location",
                controllers: [_dropControllers[0]],
                showAddRemove: false,
                onAdd: () {},
                onRemove: () {},
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _packageController,
                decoration: const InputDecoration(
                  labelText: "Package Details",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (val) => val == null || val.trim().isEmpty ? "Enter package details" : null,
              ),
              const SizedBox(height: 12),
              VoiceRecorderTextField(
                controller: _instructionController,
                decoration: const InputDecoration(
                  labelText: "Special Instructions (Optional)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                maxLength: 200,
              ),
              const SizedBox(height: 12),
              IntlPhoneField(
                controller: _altPhoneController,
                initialCountryCode: 'IN',
                showDropdownIcon: false,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone, color: appPrimaryColor),
                ),
                validator: (phone) => _validatePhoneNumber(phone?.number),
              ),
              const SizedBox(height: 16),
              MediaPreviewWidget(
                mediaFiles: _mediaFiles,
                onAddMedia: _showMediaPicker,
                onRemoveMedia: (index) => _removeMedia(index),
              ),
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
            title: Text("Parcel Pickup & Drop", style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600)),
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
                child: Icon(Icons.arrow_back_ios_new_outlined, color: whiteColor),
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

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parcel Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const PickupDropScreen(),
    );
  }
}

class ParcelDeliveryBloc extends Bloc<dynamic, dynamic> {
  ParcelDeliveryBloc() : super(null);
}

class PickupDropBloc extends Bloc<dynamic, dynamic> {
  PickupDropBloc() : super(null);
}

class PickupDropScreen extends StatelessWidget {
  const PickupDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ParcelDeliveryBloc()),
        BlocProvider(create: (_) => PickupDropBloc()),
      ],
      child: const PickupDropView(),
    );
  }
}

class PickupDropView extends StatefulWidget {
  const PickupDropView({super.key});

  @override
  State<PickupDropView> createState() => _PickupDropViewState();
}

class _PickupDropViewState extends State<PickupDropView> {
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
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
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
            leading: const Icon(Icons.camera_alt, color: Colors.teal),
            title: const Text("Camera"),
            onTap: () {
              Navigator.pop(ctx);
              _pickMedia(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.teal),
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

  Widget _buildBannerSlider() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                _banners[index],
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stack) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.teal : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLocationFields(List<TextEditingController> controllers, String label, bool showAddRemove) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAddRemove)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  if (controllers.length < 3)
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                      onPressed: () => setState(() => controllers.add(TextEditingController())),
                      tooltip: 'Add $label',
                    ),
                  if (controllers.length > 1)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () => setState(() => controllers.removeLast()),
                      tooltip: 'Remove $label',
                    ),
                ],
              )
            ],
          ),
        ...List.generate(controllers.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: controllers[i],
              decoration: InputDecoration(
                labelText: '$label ${i + 1}',
                border: const OutlineInputBorder(),
                suffixIcon: i == 0 ? const Icon(Icons.location_on, color: Colors.teal) : null,
              ),
              validator: (value) => value == null || value.trim().isEmpty ? 'Please enter $label ${i + 1}' : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMediaPreview() {
    if (_mediaFiles.isEmpty) {
      return GestureDetector(
        onTap: _showMediaPicker,
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.teal),
            color: Colors.grey[200],
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate, color: Colors.teal, size: 30),
                SizedBox(height: 8),
                Text("Add Images or Videos (Optional)", style: TextStyle(color: Colors.teal)),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Uploaded Media", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._mediaFiles.asMap().entries.map((entry) {
                final index = entry.key;
                final file = entry.value;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          file,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, stack) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red, size: 20),
                          onPressed: () => _removeMedia(index),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (_mediaFiles.length < 3)
                GestureDetector(
                  onTap: _showMediaPicker,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal),
                      color: Colors.grey[200],
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.teal, size: 30),
                          SizedBox(height: 4),
                          Text("Add More", style: TextStyle(color: Colors.teal)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
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
              const Text(
                "Select Vehicle",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildVehicleOption(
                icon: Icons.electric_bike,
                name: "Bike",
                selected: _selectedVehicle == "Bike",
                onTap: () {
                  setState(() => _selectedVehicle = "Bike");
                  Navigator.pop(context);
                  _showPaymentMethodSelection();
                },
                color: Colors.teal,
              ),
              const SizedBox(height: 8),
              _buildVehicleOption(
                icon: Icons.directions_car,
                name: "Car",
                selected: _selectedVehicle == "Car",
                onTap: () {
                  setState(() => _selectedVehicle = "Car");
                  Navigator.pop(context);
                  _showPaymentMethodSelection();
                },
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleOption({
    required IconData icon,
    required String name,
    required bool selected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? color : Colors.grey),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? color : Colors.black,
              ),
            ),
            const Spacer(),
            if (selected)
              Icon(Icons.check, color: color, size: 20),
          ],
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
              _buildPaymentMethodOptionDialog("Online", Icons.credit_card, () {
                setState(() => _selectedPaymentMethod = "Online");
                Navigator.pop(context);
                _showPaymentSummary();
              }),
              const SizedBox(height: 8),
              _buildPaymentMethodOptionDialog("COD", Icons.money, () {
                setState(() => _selectedPaymentMethod = "COD");
                Navigator.pop(context);
                _showPaymentSummary();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOptionDialog(String method, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 12),
            Text(method),
          ],
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
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vehicle: $_selectedVehicle",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text("# Total 3.14 km", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text("Payment Details", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildPaymentRow(
                  "Base Fare",
                  _selectedVehicle == "Bike" ? "20.00" : "40.00",
                  icon: Icons.price_change,
                ),
                _buildPaymentRow(
                  "Distance Charge",
                  _selectedVehicle == "Bike" ? "19.00" : "39.00",
                  icon: Icons.directions,
                ),
                _buildPaymentRow(
                  "Additional 0.1 km",
                  _selectedVehicle == "Bike" ? "1.40" : "2.80",
                  icon: Icons.add_road,
                ),
                _buildPaymentRow(
                  "To Pay",
                  _selectedVehicle == "Bike" ? "40.40" : "81.80",
                  isTotal: true,
                  icon: Icons.payments,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Place Order",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, String amount, {bool isTotal = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: Colors.teal),
                const SizedBox(width: 8),
              ],
              Text(label, style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Colors.teal : null,
              )),
            ],
          ),
          Text(amount, style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.teal : null,
            fontSize: isTotal ? 18 : null,
          )),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Order", style: TextStyle(color: Colors.teal)),
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
            Text(
              _selectedVehicle == "Bike" ? "₹40.40" : "₹81.80",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCEL", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Order placed successfully!"),
                  backgroundColor: Colors.teal,
                ),
              );
            },
            child: const Text("CONFIRM", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _showVehicleSelectionDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please fill all required fields correctly"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        icon: const Icon(Icons.send, color: Colors.white),
        label: const Text("Continue", style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parcel Pickup & Drop"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<PickupDropBloc, dynamic>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildBannerSlider(),
                  const SizedBox(height: 24),
                  ToggleButtons(
                    isSelected: [_pickupType == 0, _pickupType == 1, _pickupType == 2],
                    onPressed: (index) => setState(() => _pickupType = index),
                    borderRadius: BorderRadius.circular(8),
                    selectedColor: Colors.white,
                    fillColor: Colors.teal,
                    color: Colors.teal,
                    children: const [
                      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Single")),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Multi Pickup")),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Multi Drop")),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_pickupType == 1)
                    _buildLocationFields(_pickupControllers, "Pickup Location", true)
                  else
                    _buildLocationFields([_pickupControllers[0]], "Pickup Location", false),
                  if (_pickupType == 2)
                    _buildLocationFields(_dropControllers, "Drop Location", true)
                  else
                    _buildLocationFields([_dropControllers[0]], "Drop Location", false),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _packageController,
                    decoration: const InputDecoration(
                      labelText: "Package Details",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory, color: Colors.teal),
                    ),
                    maxLines: 2,
                    validator: (val) => val == null || val.trim().isEmpty ? "Enter package details" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _instructionController,
                    decoration: const InputDecoration(
                      labelText: "Special Instructions (Optional)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note, color: Colors.teal),
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
                      prefixIcon: Icon(Icons.phone, color: Colors.teal),
                    ),
                    validator: (phone) => _validatePhoneNumber(phone?.number),
                  ),
                  const SizedBox(height: 16),
                  _buildMediaPreview(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:sentinix_ecommerce/Reusable/customTextfield.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

// Pincode Service for Tirunelveli
class PincodeService {
  static Future<Map<String, String>?> getLocationFromPincode(String pincode) async {
    // Tirunelveli pincodes
    final pincodeData = {
      '627001': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
      '627002': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
      '627003': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
      '627004': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
      '627005': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
      '627006': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
      '627007': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
      '627008': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
      '627009': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
      '627011': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
      '627012': {'district': 'Tirunelveli', 'state': 'Tamil Nadu'},
    };

    await Future.delayed(const Duration(milliseconds: 300));
    return pincodeData[pincode]?.cast<String, String>();
  }
}

// Address Model
class Address {
  final String id;
  final String title;
  final String fullAddress;
  final String displayAddress;
  final LatLng coordinates;
  final String houseNo;
  final String floorNo;
  final String? buildingName;
  final String? street;
  final String? area;
  final String city;
  final String state;
  final String pincode;
  final String country;

  Address({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.displayAddress,
    required this.coordinates,
    required this.houseNo,
    required this.floorNo,
    this.buildingName,
    this.street,
    this.area,
    required this.city,
    required this.state,
    required this.pincode,
    this.country = "India",
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'fullAddress': fullAddress,
    'displayAddress': displayAddress,
    'coordinates': {
      'lat': coordinates.latitude,
      'lng': coordinates.longitude,
    },
    'houseNo': houseNo,
    'floorNo': floorNo,
    'buildingName': buildingName,
    'street': street,
    'area': area,
    'city': city,
    'state': state,
    'pincode': pincode,
    'country': country,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'],
    title: json['title'],
    fullAddress: json['fullAddress'],
    displayAddress: json['displayAddress'],
    coordinates: LatLng(
      json['coordinates']['lat'],
      json['coordinates']['lng'],
    ),
    houseNo: json['houseNo'],
    floorNo: json['floorNo'],
    buildingName: json['buildingName'],
    street: json['street'],
    area: json['area'],
    city: json['city'],
    state: json['state'],
    pincode: json['pincode'],
    country: json['country'],
  );
}

// BLoC Events
abstract class AddressFlowEvent {}

class ChangeStepEvent extends AddressFlowEvent {
  final int step;
  ChangeStepEvent(this.step);
}

class SelectLocationEvent extends AddressFlowEvent {
  final LatLng location;
  final String address;
  final String displayAddress;
  final String pincode;
  final String city;
  final String state;

  SelectLocationEvent(
      this.location,
      this.address,
      this.displayAddress,
      this.pincode,
      this.city,
      this.state,
      );
}

class AddAddressEvent extends AddressFlowEvent {
  final BuildContext context;
  final String houseNo;
  final String floorNo;
  final String? buildingName;
  final String? street;
  final String? area;
  final String addressType;
  final String? customAddressType;

  AddAddressEvent(
      this.context,
      this.houseNo,
      this.floorNo,
      this.buildingName,
      this.street,
      this.area,
      this.addressType,
      this.customAddressType,
      );
}

class RemoveAddressEvent extends AddressFlowEvent {
  final String addressId;
  final BuildContext context;
  RemoveAddressEvent(this.addressId, this.context);
}

class ClearTemporaryAddressEvent extends AddressFlowEvent {}

// BLoC State
class AddressFlowState {
  final int currentStep;
  final List<Address> addresses;
  final LatLng? selectedLocation;
  final String selectedAddress;
  final String displayAddress;
  final String? selectedPincode;
  final String? selectedCity;
  final String? selectedState;
  final LatLng initialPosition;
  final bool hasReachedLimit;

  AddressFlowState({
    required this.currentStep,
    required this.addresses,
    this.selectedLocation,
    this.selectedAddress = "Tap on map to select location",
    this.displayAddress = "",
    this.selectedPincode,
    this.selectedCity,
    this.selectedState,
    required this.initialPosition,
    this.hasReachedLimit = false,
  });

  AddressFlowState copyWith({
    int? currentStep,
    List<Address>? addresses,
    LatLng? selectedLocation,
    String? selectedAddress,
    String? displayAddress,
    String? selectedPincode,
    String? selectedCity,
    String? selectedState,
    LatLng? initialPosition,
    bool? hasReachedLimit,
  }) {
    return AddressFlowState(
      currentStep: currentStep ?? this.currentStep,
      addresses: addresses ?? this.addresses,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      displayAddress: displayAddress ?? this.displayAddress,
      selectedPincode: selectedPincode ?? this.selectedPincode,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedState: selectedState ?? this.selectedState,
      initialPosition: initialPosition ?? this.initialPosition,
      hasReachedLimit: hasReachedLimit ?? this.hasReachedLimit,
    );
  }
}

// BLoC
class AddressFlowBloc extends Bloc<AddressFlowEvent, AddressFlowState> {
  late GoogleMapController _mapController;
  static const LatLng tirunelveliPosition = LatLng(8.7139, 77.7567);
  static const int maxAddresses = 10;

  AddressFlowBloc({LatLng? initialPosition})
      : super(AddressFlowState(
    currentStep: 0,
    addresses: [],
    initialPosition: initialPosition ?? tirunelveliPosition,
  )) {
    on<ChangeStepEvent>((event, emit) {
      emit(state.copyWith(currentStep: event.step));
    });

    on<SelectLocationEvent>((event, emit) {
      emit(state.copyWith(
        selectedLocation: event.location,
        selectedAddress: event.address,
        displayAddress: event.displayAddress,
        selectedPincode: event.pincode,
        selectedCity: event.city,
        selectedState: event.state,
      ));
    });

    on<AddAddressEvent>((event, emit) async {
      if (state.addresses.length >= maxAddresses) {
        emit(state.copyWith(hasReachedLimit: true));
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Text(
              "Maximum $maxAddresses addresses reached",
              style: MyTextStyle.f14(whiteColor),
            ),
          ),
        );
        return;
      }

      final title = event.addressType == "OTHERS"
          ? event.customAddressType ?? "OTHER"
          : event.addressType;

      // Build address parts
      final addressParts = [
        event.houseNo,
        event.floorNo,
        if (event.buildingName?.isNotEmpty ?? false) event.buildingName,
        if (event.street?.isNotEmpty ?? false) event.street,
        if (event.area?.isNotEmpty ?? false) event.area,
        state.selectedCity ?? 'Tirunelveli',
        state.selectedState ?? 'Tamil Nadu',
        state.selectedPincode ?? '',
      ].where((part) => part != null && part.isNotEmpty).toList();

      final newAddress = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        fullAddress: addressParts.join(", "),
        displayAddress: event.area?.isNotEmpty ?? false
            ? "${event.area}, ${state.selectedCity ?? 'Tirunelveli'}"
            : state.selectedCity ?? 'Tirunelveli',
        coordinates: state.selectedLocation!,
        houseNo: event.houseNo,
        floorNo: event.floorNo,
        buildingName: event.buildingName,
        street: event.street,
        area: event.area,
        city: state.selectedCity ?? 'Tirunelveli',
        state: state.selectedState ?? 'Tamil Nadu',
        pincode: state.selectedPincode ?? '',
      );

      final updatedAddresses = List<Address>.from(state.addresses)..add(newAddress);
      await _saveAddresses(updatedAddresses);

      emit(state.copyWith(
        addresses: updatedAddresses,
        currentStep: 0,
        selectedLocation: null,
        selectedAddress: "Tap on map to select location",
        displayAddress: "",
        selectedPincode: null,
        selectedCity: null,
        selectedState: null,
        hasReachedLimit: updatedAddresses.length >= maxAddresses,
      ));

      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(
          content: Text(
            "Address added successfully",
            style: MyTextStyle.f14(whiteColor),
          ),
        ),
      );
    });

    on<RemoveAddressEvent>((event, emit) async {
      final shouldDelete = await showDialog<bool>(
        context: event.context,
        builder: (context) => AlertDialog(
          title: Text("Confirm Removal", style: MyTextStyle.f18(textColorDark)),
          content: Text(
            "Are you sure you want to remove this address?",
            style: MyTextStyle.f16(textColorDark),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel", style: MyTextStyle.f16(appPrimaryColor)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Remove", style: MyTextStyle.f16(redColor)),
            ),
          ],
        ),
      ) ?? false;

      if (shouldDelete) {
        final updatedAddresses = state.addresses.where((a) => a.id != event.addressId).toList();
        await _saveAddresses(updatedAddresses);
        emit(state.copyWith(
          addresses: updatedAddresses,
          hasReachedLimit: updatedAddresses.length >= maxAddresses,
        ));
      }
    });

    on<ClearTemporaryAddressEvent>((event, emit) {
      emit(state.copyWith(
        selectedLocation: null,
        selectedAddress: "Tap on map to select location",
        displayAddress: "",
        selectedPincode: null,
        selectedCity: null,
        selectedState: null,
      ));
    });

    _loadAddresses().then((addresses) {
      emit(state.copyWith(
        addresses: addresses,
        hasReachedLimit: addresses.length >= maxAddresses,
      ));
    });
  }

  Future<void> _saveAddresses(List<Address> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = addresses.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList('saved_addresses', addressesJson);
  }

  Future<List<Address>> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = prefs.getStringList('saved_addresses') ?? [];
    return addressesJson.map((json) => Address.fromJson(jsonDecode(json))).toList();
  }

  @override
  Future<void> close() {
    _mapController.dispose();
    return super.close();
  }
}

// Main Screen
class AddressFlowScreen extends StatelessWidget {
  final LatLng? initialPosition;

  const AddressFlowScreen({
    super.key,
    this.initialPosition,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressFlowBloc(initialPosition: initialPosition),
      child: const AddressFlowScreenView(),
    );
  }
}

class AddressFlowScreenView extends StatefulWidget {
  const AddressFlowScreenView({super.key});

  @override
  State<AddressFlowScreenView> createState() => _AddressFlowScreenViewState();
}

class _AddressFlowScreenViewState extends State<AddressFlowScreenView> {
  @override
  void dispose() {
    context.read<AddressFlowBloc>().add(ClearTemporaryAddressEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AddressFlowBloc, AddressFlowState>(
          builder: (context, state) {
            return Text(
              state.currentStep == 0
                  ? "Select Address"
                  : state.currentStep == 1
                  ? "Select Location"
                  : "Add Address Details",
              style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600),
            );
          },
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () {
            final bloc = context.read<AddressFlowBloc>();
            if (bloc.state.currentStep > 0) {
              bloc.add(ChangeStepEvent(bloc.state.currentStep - 1));
            } else {
              Navigator.pop(context);
            }
          },
        ),
        backgroundColor: appPrimaryColor,
      ),
      body: BlocBuilder<AddressFlowBloc, AddressFlowState>(
        builder: (context, state) {
          switch (state.currentStep) {
            case 0:
              return const AddressSelectionStep();
            case 1:
              return const MapSelectionStep();
            case 2:
              return const AddressDetailsStep();
            default:
              return Container();
          }
        },
      ),
    );
  }
}

// Step 1: Address Selection
class AddressSelectionStep extends StatelessWidget {
  const AddressSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddressFlowBloc>();
    final state = context.watch<AddressFlowBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: state.addresses.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, size: 64, color: greyColor),
                const SizedBox(height: 16),
                Text(
                  "No Address added yet",
                  style: MyTextStyle.f16(greyColor),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => bloc.add(ChangeStepEvent(1)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "+ Add new Address",
                    style: MyTextStyle.f16(whiteColor),
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            itemCount: state.addresses.length,
            itemBuilder: (context, index) {
              final address = state.addresses[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: appPrimaryColor),
                  title: Text(
                    address.title,
                    style: MyTextStyle.f16(textColorDark, weight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (address.buildingName?.isNotEmpty ?? false)
                        Text(
                          address.buildingName!,
                          style: MyTextStyle.f14(textColorDark),
                        ),
                      Text(
                        'House No: ${address.houseNo}, Floor No: ${address.floorNo}',
                        style: MyTextStyle.f14(textColorDark),
                      ),
                      if (address.street?.isNotEmpty ?? false)
                        Text(
                          address.street!,
                          style: MyTextStyle.f14(textColorDark),
                        ),
                      if (address.area?.isNotEmpty ?? false)
                        Text(
                          address.area!,
                          style: MyTextStyle.f14(textColorDark),
                        ),
                      Text(
                        '${address.city}, ${address.state} ${address.pincode}',
                        style: MyTextStyle.f14(greyColor),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: redColor),
                    onPressed: () => bloc.add(RemoveAddressEvent(address.id, context)),
                  ),
                  onTap: () {
                    Navigator.pop(context, address);
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.hasReachedLimit
                  ? null
                  : () => bloc.add(ChangeStepEvent(1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: state.hasReachedLimit ? greyColor : appPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                state.hasReachedLimit
                    ? "Maximum addresses reached (10)"
                    : "+ Add new Address",
                style: MyTextStyle.f18(whiteColor, weight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Step 2: Map Selection
class MapSelectionStep extends StatelessWidget {
  const MapSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddressFlowBloc>();
    final state = context.watch<AddressFlowBloc>().state;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: state.selectedLocation ?? state.initialPosition,
            zoom: 15,
          ),
          onMapCreated: (controller) => bloc._mapController = controller,
          onTap: (LatLng location) async {
            try {
              List<Placemark> placemarks = await placemarkFromCoordinates(
                location.latitude,
                location.longitude,
              );

              String displayAddress = "";
              String pincode = "";
              String city = "Tirunelveli";
              String stateName = "Tamil Nadu";

              if (placemarks.isNotEmpty) {
                final place = placemarks.first;
                displayAddress = [
                  place.street,
                  place.subLocality,
                ].where((part) => part != null && part!.isNotEmpty).join(", ");

                pincode = place.postalCode ?? "";
                city = place.locality ?? "Tirunelveli";
                stateName = place.administrativeArea ?? "Tamil Nadu";
              }

              bloc.add(SelectLocationEvent(
                location,
                "Selected Location (${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)})",
                displayAddress.isNotEmpty ? displayAddress : "Selected Location",
                pincode,
                city,
                stateName,
              ));
            } catch (e) {
              bloc.add(SelectLocationEvent(
                location,
                "Selected Location (${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)})",
                "Selected Location",
                "",
                "Tirunelveli",
                "Tamil Nadu",
              ));
            }
          },
          markers: {
            if (state.selectedLocation != null)
              Marker(
                markerId: const MarkerId("selected_location"),
                position: state.selectedLocation!,
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
                onPressed: () => bloc._mapController.animateCamera(
                  CameraUpdate.zoomIn(),
                ),
                backgroundColor: whiteColor,
                child: const Icon(Icons.add, color: appPrimaryColor),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: "zoom_out",
                onPressed: () => bloc._mapController.animateCamera(
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
                  state.displayAddress.isNotEmpty
                      ? state.displayAddress
                      : state.selectedAddress,
                  style: MyTextStyle.f16(textColorDark),
                ),
                const SizedBox(height: 8),
                if (state.selectedPincode?.isNotEmpty ?? false)
                  Text(
                    "Pincode: ${state.selectedPincode}",
                    style: MyTextStyle.f14(greyColor),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.selectedLocation != null
                        ? () => bloc.add(ChangeStepEvent(2))
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.selectedLocation != null
                          ? appPrimaryColor
                          : greyColor,
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
    );
  }
}

// Step 3: Address Details
class AddressDetailsStep extends StatefulWidget {
  const AddressDetailsStep({super.key});

  @override
  State<AddressDetailsStep> createState() => _AddressDetailsStepState();
}

class _AddressDetailsStepState extends State<AddressDetailsStep> {
  final _houseNoController = TextEditingController();
  final _floorNoController = TextEditingController();
  final _buildingController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _customTypeController = TextEditingController();
  String _addressType = "HOME";
  String? _floorNumberError;
  bool _isFormValid = false;

  @override
  void dispose() {
    _houseNoController.dispose();
    _floorNoController.dispose();
    _buildingController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _customTypeController.dispose();
    super.dispose();
  }

  bool _validateFloorNumber(String value) {
    return RegExp(r'^[0-9A-Za-z\- ]+$').hasMatch(value);
  }

  void _validateForm() {
    setState(() {
      _floorNumberError = _validateFloorNumber(_floorNoController.text)
          ? null
          : "Only alphanumeric characters and hyphens allowed";

      _isFormValid = _houseNoController.text.isNotEmpty &&
          _floorNoController.text.isNotEmpty &&
          _floorNumberError == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddressFlowBloc>();
    final state = context.watch<AddressFlowBloc>().state;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.displayAddress.isNotEmpty
                ? state.displayAddress
                : state.selectedAddress,
            style: MyTextStyle.f16(textColorDark),
          ),
          const SizedBox(height: 8),
          Text(
            "Selected Location",
            style: MyTextStyle.f14(greyColor),
          ),
          const SizedBox(height: 24),

          // House/Flat Number (Required)
          CustomTextField(
            controller: _houseNoController,
            hint: "House / Flat no *",
            onChanged: (value) => _validateForm(),
          ),
          const SizedBox(height: 16),

          // Floor Number (Required with validation)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _floorNoController,
                hint: "Floor number *",
                onChanged: (value) {
                  _validateForm();
                },
              ),
              if (_floorNumberError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _floorNumberError!,
                    style: MyTextStyle.f12(redColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Building/Apartment Name (Optional)
          CustomTextField(
            controller: _buildingController,
            hint: "Apartment / Building name (Optional)",
          ),
          const SizedBox(height: 16),

          // Street (Optional)
          CustomTextField(
            controller: _streetController,
            hint: "Street (Optional)",
          ),
          const SizedBox(height: 16),

          // Area (Optional)
          CustomTextField(
            controller: _areaController,
            hint: "Area/Locality (Optional)",
          ),
          const SizedBox(height: 16),

          // Pincode (Display only)
          if (state.selectedPincode?.isNotEmpty ?? false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pincode",
                  style: MyTextStyle.f14(greyColor),
                ),
                const SizedBox(height: 4),
                Text(
                  state.selectedPincode!,
                  style: MyTextStyle.f16(textColorDark),
                ),
                const SizedBox(height: 16),
              ],
            ),

          // Address Type Selection
          const SizedBox(height: 16),
          Text(
            "Save this address as *",
            style: MyTextStyle.f16(textColorDark, weight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: Text(
                    "HOME",
                    style: MyTextStyle.f14(_addressType == "HOME" ? whiteColor : textColorDark),
                  ),
                  selected: _addressType == "HOME",
                  onSelected: (selected) {
                    setState(() {
                      _addressType = "HOME";
                    });
                  },
                  selectedColor: appPrimaryColor,
                  backgroundColor: greyShade300,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: Text(
                    "OFFICE",
                    style: MyTextStyle.f14(_addressType == "OFFICE" ? whiteColor : textColorDark),
                  ),
                  selected: _addressType == "OFFICE",
                  onSelected: (selected) {
                    setState(() {
                      _addressType = "OFFICE";
                    });
                  },
                  selectedColor: appPrimaryColor,
                  backgroundColor: greyShade300,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: Text(
                    "OTHERS",
                    style: MyTextStyle.f14(_addressType == "OTHERS" ? whiteColor : textColorDark),
                  ),
                  selected: _addressType == "OTHERS",
                  onSelected: (selected) {
                    setState(() {
                      _addressType = "OTHERS";
                    });
                  },
                  selectedColor: appPrimaryColor,
                  backgroundColor: greyShade300,
                ),
              ),
            ],
          ),

          if (_addressType == "OTHERS") ...[
            const SizedBox(height: 16),
            CustomTextField(
              controller: _customTypeController,
              hint: "Enter address type (e.g., Friend's place) (Optional)",
            ),
          ],
          const SizedBox(height: 32),

          // Add Address Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isFormValid
                  ? () => bloc.add(AddAddressEvent(
                context,
                _houseNoController.text,
                _floorNoController.text,
                _buildingController.text.isNotEmpty ? _buildingController.text : null,
                _streetController.text.isNotEmpty ? _streetController.text : null,
                _areaController.text.isNotEmpty ? _areaController.text : null,
                _addressType,
                _addressType == "OTHERS" ? _customTypeController.text : null,
              ))
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid
                    ? appPrimaryColor
                    : greyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Add Address",
                style: MyTextStyle.f18(whiteColor, weight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
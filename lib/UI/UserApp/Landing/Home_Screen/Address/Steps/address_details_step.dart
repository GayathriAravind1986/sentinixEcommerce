import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sentinix_ecommerce/Alertbox/snackBarAlert.dart';
import 'package:sentinix_ecommerce/Bloc/UserApp/Address/address_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/ModelClass/UserApp/Address/Post_address_model.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/customTextfield.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Address/Steps/address_selection_step.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Parcel_Pickup_Drop/parcel_pickup_drop.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/person_pickup_drop.dart';

class AddressDetailsStep extends StatelessWidget {
  final dynamic from;
  final dynamic pinCode;
  final dynamic address;
  final double? lat;
  final double? lon;
  final dynamic area;
  final dynamic city;
  const AddressDetailsStep({
    super.key,
    this.from,
    this.pinCode,
    this.address,
    this.lat,
    this.lon,
    this.area,
    this.city,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddAddressBloc(),
      child: AddressDetailsStepView(
        from: from,
        pinCode: pinCode,
        address: address,
        lat: lat,
        lon: lon,
        area: area,
        city: city,
      ),
    );
  }
}

class AddressDetailsStepView extends StatefulWidget {
  final dynamic from;
  final dynamic pinCode;
  final dynamic address;
  final double? lat;
  final double? lon;
  final dynamic area;
  final dynamic city;
  const AddressDetailsStepView({
    super.key,
    this.from,
    this.pinCode,
    this.address,
    this.lat,
    this.lon,
    this.area,
    this.city,
  });

  @override
  AddressDetailsStepViewState createState() => AddressDetailsStepViewState();
}

class AddressDetailsStepViewState extends State<AddressDetailsStepView> {
  PostAddressModel postAddressModel = PostAddressModel();

  TextEditingController houseNoController = TextEditingController();
  TextEditingController floorNoController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController customTypeController = TextEditingController();
  String _addressType = "HOME";
  String? _floorNumberError;
  bool _isFormValid = false;

  @override
  void dispose() {
    houseNoController.dispose();
    floorNoController.dispose();
    buildingController.dispose();
    streetController.dispose();
    areaController.dispose();
    customTypeController.dispose();
    super.dispose();
  }

  bool _validateFloorNumber(String value) {
    return RegExp(r'^[0-9A-Za-z\- ]+$').hasMatch(value);
  }

  void _validateForm() {
    setState(() {
      _floorNumberError = _validateFloorNumber(floorNoController.text)
          ? null
          : "Only alphanumeric characters and hyphens allowed";

      _isFormValid = houseNoController.text.isNotEmpty &&
          floorNoController.text.isNotEmpty &&
          _floorNumberError == null;
    });
  }

  /// KM calculation

  bool addressLoad = false;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    areaController.text = widget.area;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget mainContainer() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.address ?? "",
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
              controller: houseNoController,
              hint: "House / Flat no *",
              onChanged: (value) => _validateForm(),
            ),
            const SizedBox(height: 16),

            // Floor Number (Required with validation)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: floorNoController,
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
              controller: buildingController,
              hint: "Apartment / Building name (Optional)",
            ),
            const SizedBox(height: 16),

            // Street (Optional)
            CustomTextField(
              controller: streetController,
              hint: "Street (Optional)",
            ),
            const SizedBox(height: 16),

            // Area (Optional)
            CustomTextField(
              controller: areaController,
              hint: "Area/Locality (Optional)",
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PinCode",
                  style: MyTextStyle.f14(greyColor),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.pinCode}",
                  style: MyTextStyle.f16(textColorDark),
                ),
                const SizedBox(height: 16),
              ],
            ),

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
                      style: MyTextStyle.f14(
                          _addressType == "HOME" ? whiteColor : textColorDark),
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
                      style: MyTextStyle.f14(_addressType == "OFFICE"
                          ? whiteColor
                          : textColorDark),
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
                      style: MyTextStyle.f14(_addressType == "OTHERS"
                          ? whiteColor
                          : textColorDark),
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
                controller: customTypeController,
                hint: "Enter address type (e.g., Friend's place) (Optional)",
              ),
            ],
            const SizedBox(height: 32),

            // Add Address Button
            addressLoad
                ? const SpinKitCircle(color: appPrimaryColor, size: 30)
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isFormValid) {
                          setState(() {
                            addressLoad = true;
                          });
                          context.read<AddAddressBloc>().add(AddAddress(
                                (widget.lat ?? 0.0).toString(),
                                (widget.lon ?? 0.0).toString(),
                                widget.city,
                                houseNoController.text,
                                floorNoController.text,
                                buildingController.text,
                                streetController.text,
                                areaController.text,
                                widget.pinCode,
                                _addressType == "OTHERS"
                                    ? customTypeController.text
                                    : _addressType,
                              ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isFormValid ? appPrimaryColor : greyColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Add Address",
                        style: MyTextStyle.f18(whiteColor,
                            weight: FontWeight.bold),
                      ),
                    ),
                  ),
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: whiteColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: appPrimaryColor,
            title: Text("Add Address Details",
                style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600)),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                widget.from == "ride"
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PersonPickupDropScreen()),
                      )
                    : Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => PickupDropScreen()),
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
        body: BlocBuilder<AddAddressBloc, dynamic>(
          buildWhen: ((previous, current) {
            debugPrint("current:$current");
            if (current is PostAddressModel) {
              postAddressModel = current;
              if (current.errorResponse != null) {
                if (current.errorResponse!.errors != null &&
                    current.errorResponse!.errors!.isNotEmpty) {
                  errorMessage = current.errorResponse!.errors![0].message ??
                      "Something went wrong";
                } else {
                  errorMessage = "Something went wrong";
                }
                showToast("$errorMessage", context, color: false);
                setState(() {
                  addressLoad = false;
                });
              } else if (postAddressModel.success == true) {
                if (postAddressModel.data!.status == true) {
                  setState(() {
                    addressLoad = false;
                  });
                  if (widget.from == "ride") {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PersonPickupDropScreen()));
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => PickupDropScreen()));
                  }
                }
                if (postAddressModel.data!.status == false) {
                  showToast('${postAddressModel.data!.message}', context,
                      color: false);
                  setState(() {
                    addressLoad = false;
                  });
                }
              }
              return true;
            }
            return false;
          }),
          builder: (context, dynamic) {
            return mainContainer();
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/customTextfield.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Parcel_Pickup_Drop/parcel_pickup_drop.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/person_pickup_drop.dart';

class AddressDetailsStep extends StatelessWidget {
  final from;
  const AddressDetailsStep({
    super.key,
    this.from,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: AddressDetailsStepView(from: from),
    );
  }
}

class AddressDetailsStepView extends StatefulWidget {
  final from;
  const AddressDetailsStepView({
    super.key,
    this.from,
  });

  @override
  AddressDetailsStepViewState createState() => AddressDetailsStepViewState();
}

class AddressDetailsStepViewState extends State<AddressDetailsStepView> {
  // GetUserDetailsModel getUserDetailsModel = GetUserDetailsModel();
  // PostPolicyModel postPolicyModel = PostPolicyModel();
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

  bool profileLoad = false;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    // context.read<UserDetailsBloc>().add(UserDetail());
    // context.read<UserDetailsBloc>().add(Policy());
    profileLoad = true;
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
              "",
              // state.displayAddress.isNotEmpty
              //     ? state.displayAddress
              //     : state.selectedAddress,
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
            //  if (state.selectedPincode?.isNotEmpty ?? false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pincode",
                  style: MyTextStyle.f14(greyColor),
                ),
                const SizedBox(height: 4),
                Text(
                  "",
                  // state.selectedPincode!,
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
                controller: _customTypeController,
                hint: "Enter address type (e.g., Friend's place) (Optional)",
              ),
            ],
            const SizedBox(height: 32),

            // Add Address Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                // _isFormValid
                //     ? () => bloc.add(AddAddressEvent(
                //           context,
                //           _houseNoController.text,
                //           _floorNoController.text,
                //           _buildingController.text.isNotEmpty
                //               ? _buildingController.text
                //               : null,
                //           _streetController.text.isNotEmpty
                //               ? _streetController.text
                //               : null,
                //           _areaController.text.isNotEmpty
                //               ? _areaController.text
                //               : null,
                //           _addressType,
                //           _addressType == "OTHERS"
                //               ? _customTypeController.text
                //               : null,
                //         ))
                //     : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid ? appPrimaryColor : greyColor,
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
        body: BlocBuilder<DemoBloc, dynamic>(
          buildWhen: ((previous, current) {
            debugPrint("current:$current");
            return false;
          }),
          builder: (context, dynamic) {
            return mainContainer();
          },
        ));
  }
}

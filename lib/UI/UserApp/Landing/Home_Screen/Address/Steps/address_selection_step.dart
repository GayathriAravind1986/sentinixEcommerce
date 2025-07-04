import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sentinix_ecommerce/Alertbox/snackBarAlert.dart';
import 'package:sentinix_ecommerce/Bloc/UserApp/Address/address_bloc.dart';
import 'package:sentinix_ecommerce/ModelClass/UserApp/Address/Get_address_model.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Address/Steps/map_selection_step.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Parcel_Pickup_Drop/parcel_pickup_drop.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Person_Pickup_Drop/person_pickup_drop.dart';

class AddressSelectionStep extends StatelessWidget {
  final dynamic fromTo;
  const AddressSelectionStep({
    super.key,
    this.fromTo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddAddressBloc(),
      child: AddressSelectionStepView(
        fromTo: fromTo,
      ),
    );
  }
}

class AddressSelectionStepView extends StatefulWidget {
  final dynamic fromTo;
  const AddressSelectionStepView({
    super.key,
    this.fromTo,
  });

  @override
  AddressSelectionStepViewState createState() =>
      AddressSelectionStepViewState();
}

class AddressSelectionStepViewState extends State<AddressSelectionStepView> {
  GetAddressModel getAddressModel = GetAddressModel();

  @override
  void dispose() {
    super.dispose();
  }

  bool addressLoad = false;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    context.read<AddAddressBloc>().add(FetchAddress());
    addressLoad = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContainer() {
      return addressLoad
          ? Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2),
              alignment: Alignment.center,
              child: const SpinKitChasingDots(color: appPrimaryColor, size: 30))
          : getAddressModel.data == null ||
                  getAddressModel.data!.address == null ||
                  getAddressModel.data!.address!.isEmpty
              ? Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_off,
                          size: 64, color: greyColor),
                      const SizedBox(height: 16),
                      Text(
                        "No Address added yet",
                        style: MyTextStyle.f16(greyColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapSelectionStep(
                                      fromTo: "ride"
                                      //  initialPosition: _selectedPosition,
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appPrimaryColor,
                              //state.hasReachedLimit ? greyColor : appPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              "+ Add new Address",
                              // state.hasReachedLimit
                              //     ? "Maximum addresses reached (10)"
                              //     : "+ Add new Address",
                              style: MyTextStyle.f18(whiteColor,
                                  weight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: getAddressModel.data!.address!.length,
                        itemBuilder: (context, index) {
                          final address = getAddressModel.data!.address![index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: const Icon(Icons.location_on,
                                  color: appPrimaryColor),
                              title: Text(
                                "${address.addressType}",
                                style: MyTextStyle.f16(textColorDark,
                                    weight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (address.apartmentName != null &&
                                      address.apartmentName!.isNotEmpty)
                                    Text(
                                      address.apartmentName!,
                                      style: MyTextStyle.f14(textColorDark),
                                    ),
                                  Text(
                                    'House No: ${address.flatAddress}, Floor No: ${address.floorNumber}',
                                    style: MyTextStyle.f14(textColorDark),
                                  ),
                                  if (address.streetName != null &&
                                      address.streetName!.isNotEmpty)
                                    Text(
                                      address.streetName!,
                                      style: MyTextStyle.f14(textColorDark),
                                    ),
                                  if (address.areaName != null &&
                                      address.areaName!.isNotEmpty)
                                    Text(
                                      address.areaName!,
                                      style: MyTextStyle.f14(textColorDark),
                                    ),
                                  Text(
                                    '${address.maplocation}, ${address.pinCode}',
                                    style: MyTextStyle.f14(greyColor),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: redColor),
                                onPressed: () {},
                                // bloc.add(RemoveAddressEvent(address.id, context)),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MapSelectionStep(fromTo: "ride"
                                        //  initialPosition: _selectedPosition,
                                        ),
                              ),
                            );
                          },
                          // state.hasReachedLimit
                          //     ? null
                          //     : () => bloc.add(ChangeStepEvent(1)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appPrimaryColor,
                            //state.hasReachedLimit ? greyColor : appPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            "+ Add new Address",
                            // state.hasReachedLimit
                            //     ? "Maximum addresses reached (10)"
                            //     : "+ Add new Address",
                            style: MyTextStyle.f18(whiteColor,
                                weight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
    }

    return WillPopScope(
      onWillPop: () async {
        if (widget.fromTo == "ride") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PersonPickupDropScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PickupDropScreen()),
          );
        }
        return false; // prevent default back behavior
      },
      child: Scaffold(
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
                  if (widget.fromTo == "ride") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PersonPickupDropScreen()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => PickupDropScreen()),
                    );
                  }
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
              if (current is GetAddressModel) {
                getAddressModel = current;
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
                } else if (getAddressModel.success == true) {
                  if (getAddressModel.data!.status == true) {
                    setState(() {
                      addressLoad = false;
                    });
                  }
                  if (getAddressModel.data!.status == false) {
                    showToast('${getAddressModel.data!.message}', context,
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
          )),
    );
  }
}

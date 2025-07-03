import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Address/Steps/address_details_step.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Address/Steps/address_selection_step.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Address/Steps/map_selection_step.dart';

class AddressFlowScreen extends StatelessWidget {
  const AddressFlowScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: AddressFlowScreenView(),
    );
  }
}

class AddressFlowScreenView extends StatefulWidget {
  const AddressFlowScreenView({
    super.key,
  });

  @override
  AddressFlowScreenViewState createState() => AddressFlowScreenViewState();
}

class AddressFlowScreenViewState extends State<AddressFlowScreenView> {
  // GetUserDetailsModel getUserDetailsModel = GetUserDetailsModel();
  // PostPolicyModel postPolicyModel = PostPolicyModel();
  bool profileLoad = false;
  String? errorMessage;
  int currentStep = 0;
  String getTitle(int step) {
    switch (step) {
      case 0:
        return "Select Address";
      case 1:
        return "Select Location";
      case 2:
        return "Add Address Details";
      default:
        return "Unknown";
    }
  }

  @override
  void initState() {
    super.initState();
    // context.read<UserDetailsBloc>().add(UserDetail());
    // context.read<UserDetailsBloc>().add(Policy());
    profileLoad = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget mainContainer(int currentStep) {
      switch (currentStep) {
        case 0:
          return const AddressSelectionStep();
        case 1:
          return const MapSelectionStep();
        case 2:
          return const AddressDetailsStep();
        default:
          return const Center(child: Text("Unknown Step"));
      }
    }

    return Scaffold(
        backgroundColor: whiteColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              width: double.infinity,
              height: 90,
              color: whiteColor,
              padding: const EdgeInsets.only(top: 35, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTitle(currentStep),
                    style: MyTextStyle.f20(appPrimaryColor,
                        weight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocBuilder<DemoBloc, dynamic>(
          buildWhen: ((previous, current) {
            debugPrint("current:$current");

            return false;
          }),
          builder: (context, dynamic) {
            return mainContainer(currentStep);
          },
        ));
  }
}

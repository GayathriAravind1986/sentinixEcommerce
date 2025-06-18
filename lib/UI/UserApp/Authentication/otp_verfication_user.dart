import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/elevated_button.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Authentication/login.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Navigation_Bar/Navigation_bar.dart';

class UserOTPVerify extends StatelessWidget {
  const UserOTPVerify({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: UserOTPVerifyView(),
    );
  }
}

class UserOTPVerifyView extends StatefulWidget {
  const UserOTPVerifyView({
    super.key,
  });

  @override
  State<UserOTPVerifyView> createState() => _UserOTPVerifyViewState();
}

class _UserOTPVerifyViewState extends State<UserOTPVerifyView> {
  //GetEventModel getEventModel = GetEventModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? errorMessage;
  bool loginLoad = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget mainContainer() {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.splashLogo,
                    height: size.height * 0.25,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "OTP verification",
                    style: MyTextStyle.f22(
                      blackColor,
                      weight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter the OTP sent to your phone",
                    style: MyTextStyle.f16(blackColor54),
                  ),
                  const SizedBox(height: 30),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    animationType: AnimationType.scale,
                    keyboardType: TextInputType.number,
                    textStyle: MyTextStyle.f20(blackColor),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 60,
                      fieldWidth: 50,
                      activeColor: appPrimaryColor,
                      selectedColor: appPrimaryColor,
                      inactiveColor: greyShade300,
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "Verify OTP",
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const DashBoardScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginCustomer()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: BlocBuilder<DemoBloc, dynamic>(
          buildWhen: (previous, current) {
            return false;
          },
          builder: (context, dynamic) {
            return mainContainer();
          },
        ),
      ),
    );
  }
}

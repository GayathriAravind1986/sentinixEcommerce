import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/custom_phone_field.dart';
import 'package:sentinix_ecommerce/Reusable/elevated_button.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/DeliveryApp/Authentication/Widget/signup_delivery_animation_widget.dart';
import 'package:sentinix_ecommerce/UI/DeliveryApp/Authentication/deliveryman_signup.dart';
import 'package:sentinix_ecommerce/UI/DeliveryApp/Authentication/otp_verification_delivery.dart';

class LoginDeliveryMan extends StatelessWidget {
  const LoginDeliveryMan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: LoginDeliveryManView(),
    );
  }
}

class LoginDeliveryManView extends StatefulWidget {
  const LoginDeliveryManView({
    super.key,
  });

  @override
  State<LoginDeliveryManView> createState() => _LoginDeliveryManViewState();
}

class _LoginDeliveryManViewState extends State<LoginDeliveryManView> {
  //GetEventModel getEventModel = GetEventModel();
  String? errorMessage;
  bool loginLoad = true;
  String completePhoneNumber = '';
  List<TextInputFormatter> formatters = [LengthLimitingTextInputFormatter(10)];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget mainContainer() {
      return SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    Images.loginImage,
                    height: size.height * 0.3,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Phone Number",
                  style: MyTextStyle.f20(blackColor),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please enter your phone number to get one time password",
                  style: MyTextStyle.f14(greyColor),
                ),
                const SizedBox(height: 20),
                CustomPhoneField(
                  onPhoneChanged: (value) {
                    setState(() {
                      completePhoneNumber = value;
                    });
                  },
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: "Continue",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DeliveryOTPVerify()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: MyTextStyle.f14(greyColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const DeliveryManSignup()),
                          );
                        },
                        child: Text(
                          "Sign up",
                          style: MyTextStyle.f14(appPrimaryColor).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.1),
                const AnimatedLoginDelivery(),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocBuilder<DemoBloc, dynamic>(
        buildWhen: (previous, current) {
          return false;
        },
        builder: (context, dynamic) {
          return mainContainer();
        },
      ),
    );
  }
}

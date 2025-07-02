import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sentinix_ecommerce/Alertbox/snackBarAlert.dart';
import 'package:sentinix_ecommerce/Bloc/UserApp/Authentication/login_phone_bloc.dart';
import 'package:sentinix_ecommerce/ModelClass/UserApp/Authentication/Post_login_otp_model.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/elevated_button.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Authentication/login.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Navigation_Bar/Navigation_bar.dart';

class UserOTPVerify extends StatelessWidget {
  final String phone;
  final String otp;
  const UserOTPVerify({
    super.key,
    required this.otp,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserLoginBloc(),
      child: UserOTPVerifyView(
        phone: phone,
        otp: otp,
      ),
    );
  }
}

class UserOTPVerifyView extends StatefulWidget {
  final String phone;
  final String otp;
  const UserOTPVerifyView({
    super.key,
    required this.otp,
    required this.phone,
  });

  @override
  State<UserOTPVerifyView> createState() => _UserOTPVerifyViewState();
}

class _UserOTPVerifyViewState extends State<UserOTPVerifyView> {
  PostLoginOtpModel postLoginOtpModel = PostLoginOtpModel();
  TextEditingController otpController = TextEditingController();
  String? errorMessage;
  bool otpLoad = false;
  @override
  void initState() {
    super.initState();
    otpController = TextEditingController(text: widget.otp);
  }

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
                    controller: otpController,
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
                  otpLoad
                      ? const SpinKitCircle(color: appPrimaryColor, size: 30)
                      : CustomButton(
                          text: "Verify OTP",
                          onPressed: () {
                            debugPrint("phone:${widget.phone}");
                            debugPrint("otp:${otpController.text}");
                            if (otpController.text.isEmpty) {
                              showToast('Please enter valid otp', context,
                                  color: false);
                            } else {
                              setState(() {
                                otpLoad = true;
                              });
                              context.read<UserLoginBloc>().add(
                                  UserLoginWithOtp(
                                      widget.phone, otpController.text));
                            }
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
        body: BlocBuilder<UserLoginBloc, dynamic>(
          buildWhen: (previous, current) {
            debugPrint("current:$current");
            if (current is PostLoginOtpModel) {
              postLoginOtpModel = current;
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
                  otpLoad = false;
                });
              } else if (postLoginOtpModel.success == true) {
                if (postLoginOtpModel.data!.status == true) {
                  showToast('${postLoginOtpModel.data!.message}', context,
                      color: true);
                  setState(() {
                    otpLoad = false;
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const DashBoardScreen()),
                    (Route<dynamic> route) => false,
                  );
                }
                if (postLoginOtpModel.data!.status == false) {
                  showToast('${postLoginOtpModel.data!.message}', context,
                      color: false);
                  setState(() {
                    otpLoad = false;
                  });
                }
              }
              return true;
            }
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

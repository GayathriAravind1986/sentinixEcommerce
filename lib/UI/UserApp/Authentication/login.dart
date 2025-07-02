import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sentinix_ecommerce/Alertbox/snackBarAlert.dart';
import 'package:sentinix_ecommerce/Bloc/UserApp/Authentication/login_phone_bloc.dart';
import 'package:sentinix_ecommerce/ModelClass/UserApp/Authentication/Post_login_model.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/custom_phone_field.dart';
import 'package:sentinix_ecommerce/Reusable/elevated_button.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Authentication/Widget/signup_animation_widget.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Authentication/otp_verfication_user.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Authentication/user_signup.dart';

class LoginCustomer extends StatelessWidget {
  const LoginCustomer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserLoginBloc(),
      child: LoginCustomerView(),
    );
  }
}

class LoginCustomerView extends StatefulWidget {
  const LoginCustomerView({
    super.key,
  });

  @override
  State<LoginCustomerView> createState() => _LoginCustomerViewState();
}

class _LoginCustomerViewState extends State<LoginCustomerView> {
  PostLoginModel postLoginModel = PostLoginModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  String? errorMessage;
  bool loginLoad = false;
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
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Container(
              width: size.width,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      Images.splashLogo,
                      height: size.height * 0.25,
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
                      controller: phone,
                      onPhoneChanged: (value) {
                        setState(() {
                          completePhoneNumber = value;
                          _formKey.currentState!.validate();
                        });
                      },
                      validator: (val) {
                        if (val != null) {
                          if (val.isEmpty) {
                            return 'Please enter your phone number';
                          }
                        }
                        return null;
                      }),
                  const SizedBox(height: 30),
                  loginLoad
                      ? const SpinKitCircle(color: appPrimaryColor, size: 30)
                      : CustomButton(
                          text: "Continue",
                          onPressed: () {
                            debugPrint("phone:${phone.text}");
                            if (_formKey.currentState!.validate()) {
                              if (phone.text.isEmpty) {
                                showToast(
                                    'Please enter your phone number', context,
                                    color: false);
                              } else {
                                setState(() {
                                  loginLoad = true;
                                });
                                context.read<UserLoginBloc>().add(UserLogin(
                                      phone.text,
                                    ));
                              }
                            }
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
                                  builder: (_) => const UserSignup()),
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
                  const AnimatedLoginLink(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocBuilder<UserLoginBloc, dynamic>(
        buildWhen: (previous, current) {
          debugPrint("current:$current");
          if (current is PostLoginModel) {
            postLoginModel = current;
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
                loginLoad = false;
              });
            } else if (postLoginModel.success == true) {
              if (postLoginModel.data!.status == true) {
                setState(() {
                  loginLoad = false;
                });
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("OTP Verification"),
                      content: Text(
                          "Your OTP is: ${postLoginModel.data!.otp ?? 'N/A'}"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UserOTPVerify(
                                        phone: phone.text,
                                        otp: '${postLoginModel.data!.otp}')));
                          },
                          child: Text(
                            "OK",
                            style: MyTextStyle.f14(appPrimaryColor).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              if (postLoginModel.data!.status == false) {
                showToast('${postLoginModel.data!.message}', context,
                    color: false);
                setState(() {
                  loginLoad = false;
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/customTextfield.dart';
import 'package:sentinix_ecommerce/Reusable/custom_phone_field.dart';
import 'package:sentinix_ecommerce/Reusable/elevated_button.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/space.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Authentication/Widget/signup_label_widget.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Authentication/login.dart';

class UserSignup extends StatelessWidget {
  const UserSignup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: UserSignupView(),
    );
  }
}

class UserSignupView extends StatefulWidget {
  const UserSignupView({
    super.key,
  });

  @override
  State<UserSignupView> createState() => _UserSignupViewState();
}

class _UserSignupViewState extends State<UserSignupView> {
  //GetEventModel getEventModel = GetEventModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController alterPhone = TextEditingController();
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel("Name"),
                CustomTextField(
                    hint: "Name",
                    height: 15,
                    readOnly: false,
                    controller: name,
                    baseColor: appPrimaryColor,
                    borderColor: blackColor54,
                    errorColor: redColor,
                    inputType: TextInputType.text,
                    showSuffixIcon: false,
                    obscureText: false,
                    maxLength: 30,
                    maxLine: 1,
                    onChanged: (val) {
                      _formKey.currentState!.validate();
                    },
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'Please enter your name';
                        } else {
                          return null;
                        }
                      }
                      return null;
                    }),
                const SizedBox(height: 10),
                buildLabel("Date of birth"),
                CustomTextField(
                    hint: "Date of birth",
                    height: 15,
                    readOnly: false,
                    controller: dob,
                    baseColor: appPrimaryColor,
                    borderColor: blackColor54,
                    errorColor: redColor,
                    inputType: TextInputType.text,
                    showSuffixIcon: false,
                    obscureText: false,
                    maxLength: 15,
                    maxLine: 1,
                    onChanged: (val) {
                      _formKey.currentState!.validate();
                    },
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'Please enter your dob';
                        } else {
                          return null;
                        }
                      }
                      return null;
                    }),
                const SizedBox(height: 10),
                buildLabel("Phone No"),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: CustomPhoneField(
                    onPhoneChanged: (value) {
                      setState(() {
                        completePhoneNumber = value;
                      });
                    },
                  ),
                ),
                buildLabel("Alternative Phone No"),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: CustomPhoneField(
                    onPhoneChanged: (value) {
                      setState(() {
                        completePhoneNumber = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: "Register",
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginCustomer()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
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
        appBar: PreferredSize(
          preferredSize: size.width < 650
              ? const Size.fromHeight(55)
              : const Size.fromHeight(90),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              width: double.infinity,
              color: whiteColor,
              padding: const EdgeInsets.only(top: 35, left: 20, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginCustomer()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Image.asset(
                      alignment: Alignment.topCenter,
                      Images.backArrow,
                      width: size.width * 0.1,
                      height: size.height * 0.05,
                    ),
                  ),
                  horizontalSpace(width: 20),
                  Text("SignUp",
                      textAlign: TextAlign.start,
                      style: size.width < 650
                          ? MyTextStyle.f20(blackColor, weight: FontWeight.w600)
                          : MyTextStyle.f30(blackColor,
                              weight: FontWeight.w600)),
                ],
              ),
            ),
            elevation: 0,
            backgroundColor: whiteColor,
          ),
        ),
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

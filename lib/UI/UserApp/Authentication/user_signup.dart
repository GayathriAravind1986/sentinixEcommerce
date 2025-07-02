import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sentinix_ecommerce/Alertbox/snackBarAlert.dart';
import 'package:sentinix_ecommerce/Bloc/UserApp/Authentication/signUp_bloc.dart';
import 'package:sentinix_ecommerce/ModelClass/UserApp/Authentication/Post_User_Register_Model.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/customTextfield.dart';
import 'package:sentinix_ecommerce/Reusable/custom_phone_field.dart';
import 'package:sentinix_ecommerce/Reusable/elevated_button.dart';
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
      create: (_) => UserSignUpBloc(),
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
  PostUserRegisterModel postUserRegisterModel = PostUserRegisterModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController alterPhone = TextEditingController();
  RegExp emailRegex = RegExp(r'\S+@\S+\.\S+');
  String? errorMessage;
  bool signUpLoad = false;
  String completePhoneNumber = '';
  List<TextInputFormatter> formatters = [LengthLimitingTextInputFormatter(10)];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContainer() {
      return SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: appPrimaryColor,
                                onPrimary: whiteColor,
                                onSurface: blackColor,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: appPrimaryColor,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        dob.text = formattedDate;
                        _formKey.currentState!.validate();
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        hint: "Date of birth",
                        height: 15,
                        readOnly: true, // Important for calendar field
                        controller: dob,
                        baseColor: appPrimaryColor,
                        borderColor: blackColor54,
                        errorColor: redColor,
                        inputType: TextInputType.text,
                        showSuffixIcon: true,
                        FTextInputFormatter:
                            FilteringTextInputFormatter.allow(RegExp("[0-9-]")),
                        obscureText: false,
                        maxLength: 15,
                        maxLine: 1,
                        onChanged: (val) {
                          _formKey.currentState!.validate();
                        },
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter your dob';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildLabel("Email Address"),
                  CustomTextField(
                      hint: "Email Address",
                      readOnly: false,
                      controller: email,
                      baseColor: appPrimaryColor,
                      borderColor: blackColor54,
                      errorColor: redColor,
                      inputType: TextInputType.text,
                      showSuffixIcon: false,
                      FTextInputFormatter: FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z0-9.@]")),
                      obscureText: false,
                      maxLength: 30,
                      onChanged: (val) {
                        _formKey.currentState!.validate();
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!emailRegex.hasMatch(value)) {
                            return 'Please enter valid email';
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
                  ),
                  buildLabel("Alternative Phone No"),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: CustomPhoneField(
                      controller: alterPhone,
                      onPhoneChanged: (value) {
                        setState(() {
                          completePhoneNumber = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  signUpLoad
                      ? const SpinKitCircle(color: appPrimaryColor, size: 30)
                      : CustomButton(
                          text: "Register",
                          onPressed: () {
                            debugPrint("name:${name.text}");
                            debugPrint("phone:${phone.text}");
                            debugPrint("email:${email.text}");
                            debugPrint("alterphone:${alterPhone.text}");
                            debugPrint("dob:${dob.text}");
                            if (_formKey.currentState!.validate()) {
                              if (phone.text.isEmpty) {
                                showToast(
                                    'Please enter your phone number', context,
                                    color: false);
                              } else {
                                setState(() {
                                  signUpLoad = true;
                                });
                                context.read<UserSignUpBloc>().add(UserRegister(
                                    name.text,
                                    phone.text,
                                    email.text,
                                    alterPhone.text ?? "",
                                    dob.text));
                              }
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: appPrimaryColor,
            title: Text("Sign up",
                style: MyTextStyle.f20(whiteColor, weight: FontWeight.w600)),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const LoginCustomer()),
                  (Route<dynamic> route) => false,
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
        body: BlocBuilder<UserSignUpBloc, dynamic>(
          buildWhen: (previous, current) {
            debugPrint("current:$current");
            if (current is PostUserRegisterModel) {
              postUserRegisterModel = current;
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
                  signUpLoad = false;
                });
              } else if (postUserRegisterModel.success == true) {
                if (postUserRegisterModel.data!.status == true) {
                  showToast('${postUserRegisterModel.data!.message}', context,
                      color: true);
                  setState(() {
                    signUpLoad = false;
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginCustomer()),
                    (Route<dynamic> route) => false,
                  );
                }
                if (postUserRegisterModel.data!.status == false) {
                  showToast('${postUserRegisterModel.data!.message}', context,
                      color: false);
                  setState(() {
                    signUpLoad = false;
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

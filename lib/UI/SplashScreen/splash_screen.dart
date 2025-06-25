import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Authentication/login.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/Home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  dynamic userId;
  dynamic roleId;

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
      roleId = prefs.getString("roleId");
    });
    debugPrint("SplashUserId: $userId");
    debugPrint("SplashRoleId: $roleId");
  }

  void onTimerFinished() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginCustomer()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    getToken();
    Timer(const Duration(seconds: 5), () => onTimerFinished());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: Image.asset(
          Images.splashLogo,
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.4,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

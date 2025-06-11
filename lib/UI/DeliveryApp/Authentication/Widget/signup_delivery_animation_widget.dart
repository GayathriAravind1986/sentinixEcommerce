import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

import 'package:sentinix_ecommerce/UI/UserApp/Authentication/login.dart';

import 'package:slide_to_act/slide_to_act.dart';

class AnimatedLoginDelivery extends StatefulWidget {
  const AnimatedLoginDelivery({super.key});

  @override
  State<AnimatedLoginDelivery> createState() => _AnimatedLoginDeliveryState();
}

class _AnimatedLoginDeliveryState extends State<AnimatedLoginDelivery> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00707E),
              Color(0xFF00A8A3),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SlideAction(
          innerColor: whiteColor.withOpacity(0.2),
          outerColor: Colors.transparent,
          elevation: 0,
          borderRadius: 60,
          sliderButtonIcon:
              const Icon(Icons.arrow_forward_ios, size: 15, color: whiteColor),
          text: "Swipe as User",
          textStyle:
              MyTextStyle.f14(whiteColor).copyWith(fontWeight: FontWeight.bold),
          alignment: Alignment.centerLeft,
          onSubmit: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginCustomer()),
              (Route<dynamic> route) => false,
            );
            return null;
          },
        ),
      ),
    );
  }
}

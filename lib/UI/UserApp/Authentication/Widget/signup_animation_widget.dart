import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/UI/DeliveryApp/Authentication/login_delivery.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AnimatedLoginLink extends StatefulWidget {
  const AnimatedLoginLink({super.key});

  @override
  State<AnimatedLoginLink> createState() => _AnimatedLoginLinkState();
}

class _AnimatedLoginLinkState extends State<AnimatedLoginLink> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF57C00),
              Color(0xFFBF360C),
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
          text: "Swipe as Deliveryman",
          textStyle:
              MyTextStyle.f14(whiteColor).copyWith(fontWeight: FontWeight.bold),
          alignment: Alignment.centerLeft,
          onSubmit: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginDeliveryMan()),
              (Route<dynamic> route) => false,
            );
            return null;
          },
        ),
      ),
    );
  }
}

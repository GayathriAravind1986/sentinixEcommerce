import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class AddressSectionWidget extends StatelessWidget {
  final String title;
  final String address;

  const AddressSectionWidget({
    super.key,
    required this.title,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: MyTextStyle.f15(weight: FontWeight.bold, blackColor),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_city, color: orangeColor, size: 20),
            const SizedBox(width: 6),
            Expanded(
                child: Text(
              address,
              style: MyTextStyle.f14(weight: FontWeight.w400, blackColor),
            )),
          ],
        ),
      ],
    );
  }
}

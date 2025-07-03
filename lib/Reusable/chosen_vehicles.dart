import 'package:flutter/cupertino.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class ChosenVehicleInfo extends StatelessWidget {
  final String selectedVehicle;
  final double totalKm;
  final int totalMinutes;

  const ChosenVehicleInfo({
    super.key,
    required this.selectedVehicle,
    required this.totalKm,
    required this.totalMinutes,
  });

  @override
  Widget build(BuildContext context) {
    // Step 1: Set fare values based on vehicle
    int baseKm = 0;
    int baseMin = 0;
    int baseKmFare = 0;
    int baseMinFare = 0;
    int extraKmFare = 0;
    int extraMinFare = 0;

    switch (selectedVehicle) {
      case "Auto":
        baseKm = 2;
        baseMin = 2;
        baseKmFare = 200;
        baseMinFare = 100;
        extraKmFare = 50;
        extraMinFare = 20;
        break;
      case "Bike":
        baseKm = 2;
        baseMin = 2;
        baseKmFare = 100;
        baseMinFare = 50;
        extraKmFare = 30;
        extraMinFare = 10;
        break;
      case "Cycle":
        baseKm = 1;
        baseMin = 1;
        baseKmFare = 50;
        baseMinFare = 20;
        extraKmFare = 10;
        extraMinFare = 5;
        break;
      default:
        break;
    }

    // Step 2: Fare Calculation
    final int roundedKm = totalKm.ceil();
    final int extraKm = (roundedKm - baseKm).clamp(0, roundedKm);
    final int extraMin = (totalMinutes - baseMin).clamp(0, totalMinutes);

    final int totalKmAmount = baseKmFare + (extraKm * extraKmFare);
    final int totalMinAmount = baseMinFare + (extraMin * extraMinFare);
    final int totalFare = totalKmAmount + totalMinAmount;

    // Step 3: Show layout
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: "Chosen Vehicle: ",
              style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold),
              children: [
                TextSpan(
                  text: selectedVehicle,
                  style: MyTextStyle.f16(blackColor, weight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          _row("Base Km: ${baseKm}Km", "Base Km Fare:  ₹${baseKmFare.toStringAsFixed(2)}"),
          _row("Base Minute: ${baseMin}Min", "Base Min Fare:  ₹${baseMinFare.toStringAsFixed(2)}"),
          _row("Extra Km Fare:  ₹${extraKmFare.toStringAsFixed(2)}", "Extra Min Fare: ₹${extraMinFare.toStringAsFixed(2)}"),
          _row("Total Kms: ${roundedKm}Kms", "Total Minutes: ${totalMinutes}Min"),
          _row("Total Km Amount:  ₹${totalKmAmount.toStringAsFixed(2)}", "Total Min Fare:  ₹${totalMinAmount.toStringAsFixed(2)}"),

          const SizedBox(height: 12),
          Center(
            child: Text(
              "Total Fare: ₹${totalFare.toStringAsFixed(2)}",
              style: MyTextStyle.f22(appPrimaryColor, weight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String left, String right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: MyTextStyle.f14(blackColor)),
          Text(right, style: MyTextStyle.f14(blackColor)),
        ],
      ),
    );
  }
}

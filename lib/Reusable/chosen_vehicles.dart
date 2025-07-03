import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class ChosenVehicleDetails extends StatelessWidget {
  final String? selectedVehicle;
  final double? totalKm;

  ChosenVehicleDetails({
    required this.selectedVehicle,
    required this.totalKm,
  });

  final Map<String, double> vehicleRates = {
    'Bike': 5.0,
    'Car': 12.0,
    'Van': 10.0,
    'Cycle': 3.0,
    'Lorry': 15.0,
    'Truck': 18.0,
    'Train': 25.0,
  };

  @override
  Widget build(BuildContext context) {
    if (selectedVehicle == null) return SizedBox();

    final double? farePerKm = vehicleRates[selectedVehicle];
    final double? totalFare = (farePerKm != null && totalKm != null)
        ? (farePerKm * totalKm!)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Line 1: Chosen Vehicle, Fare per KM, Total KM
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Vehicle: $selectedVehicle",
                  style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.w600),
                ),
              ),
              if (farePerKm != null)
                Expanded(
                  child: Text(
                    "₹${farePerKm.toStringAsFixed(2)}/km",
                    style: MyTextStyle.f14(Colors.black),
                  ),
                ),
              if (totalKm != null)
                Expanded(
                  child: Text(
                    "Total: ${totalKm!.toStringAsFixed(1)} km",
                    style: MyTextStyle.f14(Colors.black),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          /// Line 2: Total Fare
          if (totalFare != null)
            Text(
              "Total Fare: ₹${totalFare.toStringAsFixed(2)}",
              style: MyTextStyle.f18(appPrimaryColor, weight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

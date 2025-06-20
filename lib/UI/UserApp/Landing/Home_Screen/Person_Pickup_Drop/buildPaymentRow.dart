import 'package:flutter/material.dart';

import 'package:sentinix_ecommerce/Reusable/color.dart';

class PaymentRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;
  final IconData? icon;

  const PaymentRow({
    super.key,
    required this.label,
    required this.amount,
    this.isTotal = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: appPrimaryColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? appPrimaryColor : null,
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? appPrimaryColor : null,
              fontSize: isTotal ? 18 : null,
            ),
          ),
        ],
      ),
    );
  }
}

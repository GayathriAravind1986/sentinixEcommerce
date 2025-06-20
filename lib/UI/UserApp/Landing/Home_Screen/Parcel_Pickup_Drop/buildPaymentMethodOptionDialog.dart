import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';

class PaymentMethodOption extends StatelessWidget {
  final String method;
  final IconData icon;
  final VoidCallback onTap;

  const PaymentMethodOption({
    super.key,
    required this.method,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: greyColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: appPrimaryColor),
            const SizedBox(width: 12),
            Text(method),
          ],
        ),
      ),
    );
  }
}

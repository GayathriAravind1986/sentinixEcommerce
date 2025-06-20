import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';

class VehicleOptionTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const VehicleOptionTile({
    super.key,
    required this.icon,
    required this.name,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : greyColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? color : greyShade300 ?? Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? color : greyColor),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? color : blackColor,
              ),
            ),
            const Spacer(),
            if (selected) Icon(Icons.check, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}

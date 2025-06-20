import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';

class LocationFields extends StatelessWidget {
  final String label;
  final List<TextEditingController> controllers;
  final bool showAddRemove;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const LocationFields({
    super.key,
    required this.label,
    required this.controllers,
    required this.showAddRemove,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAddRemove)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  // ➖ Remove Icon: Disabled when only 1 field
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: controllers.length > 1 ? onRemove : null,
                    color: controllers.length > 1
                        ? redColor
                        : Colors.grey.shade400,
                    tooltip: 'Remove $label',
                  ),

                  // ➕ Add Icon: Disabled when already 5 fields
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: controllers.length < 5 ? onAdd : null,
                    color: controllers.length < 5
                        ? appPrimaryColor
                        : Colors.grey.shade400,
                    tooltip: 'Add $label',
                  ),
                ],
              ),
            ],
          ),

        const SizedBox(height: 8),

        // All pickup/drop fields
        ...List.generate(controllers.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: controllers[i],
              decoration: InputDecoration(
                labelText:
                showAddRemove ? '$label ${i + 1}' : label,
                border: const OutlineInputBorder(),

                // 📍 Always show location icon
                suffixIcon: const Icon(Icons.location_on, color: appPrimaryColor),
              ),
              validator: (value) =>
              value == null || value.trim().isEmpty
                  ? 'Please enter ${showAddRemove ? "$label ${i + 1}" : label}'
                  : null,
            ),
          );
        }),
      ],
    );
  }
}

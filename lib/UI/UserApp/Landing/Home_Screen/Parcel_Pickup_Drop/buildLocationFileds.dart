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
                  if (controllers.length < 3)
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: appPrimaryColor),
                      onPressed: onAdd,
                      tooltip: 'Add $label',
                    ),
                  if (controllers.length > 1)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: redColor),
                      onPressed: onRemove,
                      tooltip: 'Remove $label',
                    ),
                ],
              ),
            ],
          ),
        ...List.generate(controllers.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: controllers[i],
              decoration: InputDecoration(
                labelText: '$label ${i + 1}',
                border: const OutlineInputBorder(),
                suffixIcon: i == 0
                    ? const Icon(Icons.location_on, color: appPrimaryColor)
                    : null,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter $label ${i + 1}'
                  : null,
            ),
          );
        }),
      ],
    );
  }
}

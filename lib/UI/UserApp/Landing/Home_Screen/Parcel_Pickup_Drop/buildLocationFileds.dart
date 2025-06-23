import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/customTextfield.dart';


class LocationFields extends StatelessWidget {
  final String label;
  final List<TextEditingController> controllers;
  final bool showAddRemove;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final Function(int index)? onTap;


  const LocationFields({
    super.key,
    required this.label,
    required this.controllers,
    required this.showAddRemove,
    required this.onAdd,
    required this.onRemove,
    required this.onTap,
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
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: controllers.length > 1 ? onRemove : null,
                    color: controllers.length > 1
                        ? redColor
                        : Colors.grey.shade400,
                    tooltip: 'Remove $label',
                  ),
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
            child: CustomTextField(
              hint: '$label ${i + 1}',
              controller: controllers[i],
              readOnly: true,
              onTap: () {
                if(onTap != null){
                  onTap!(i);
                }
              },
              validator: (val) => val == null || val.trim().isEmpty ? 'Enter location' : null,
            )

          );
        }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/elevated_button.dart';

class SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onValid;
  final String text;

  const SubmitButton({
    super.key,
    required this.formKey,
    required this.onValid,
    this.text = "Book Ride",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: text,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            onValid();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please fill all required fields correctly"),
                backgroundColor: redColor,
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/Reusable/space.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({super.key});

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildInputField(
              label: 'FULL NAME',
              controller: _nameController,
              hint: 'Enter your name',
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter Full Name';
                return null;
              }),
          verticalSpace(height: 12),
          _buildInputField(
              label: 'EMAIL',
              controller: _emailController,
              hint: 'Enter valid email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter Email';
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                return emailRegex.hasMatch(value) ? null : 'Enter valid email';
              }),
          verticalSpace(height: 12),
          _buildInputField(
              label: 'PHONE',
              controller: _phoneController,
              hint: 'Enter valid number',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter Phone';
                if (!RegExp(r'^\d{10}$').hasMatch(value)) return 'Enter 10-digit number';
                return null;
              }),
          verticalSpace(height: 12),
          _buildInputField(
              label: 'DATE OF BIRTH',
              controller: _dobController,
              hint: 'Enter your DOB',
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter DOB';
                return null;
              }),
          verticalSpace(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile Updated!")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appSecondaryColor,
              foregroundColor: appPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              elevation: 6,
              shadowColor: appPrimaryColor.withOpacity(0.3),
            ),
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.w600)),
        verticalSpace(height: 8),
        Container(
          decoration: BoxDecoration(
            color: appSecondaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: appPrimaryColor.withOpacity(0.3), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: appPrimaryColor.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: MyTextStyle.f16(appPrimaryColor),
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: appPrimaryColor.withOpacity(0.6)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}



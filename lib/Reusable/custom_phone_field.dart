import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class CustomPhoneField extends StatefulWidget {
  final Function(String completePhoneNumber) onPhoneChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const CustomPhoneField({
    super.key,
    required this.onPhoneChanged,
    this.controller,
    this.validator,
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  List<TextInputFormatter> formatters = [LengthLimitingTextInputFormatter(10)];
  final Map<String, int> countryMaxLengths = {
    'IN': 10,
    'US': 10,
    'AE': 9,
    'GB': 10,
    'AU': 9,
  };

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: MyTextStyle.f14(greyColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      controller: widget.controller,
      initialCountryCode: 'IN',
      showCountryFlag: false,
      showDropdownIcon: false,
      flagsButtonMargin: const EdgeInsets.only(right: 0),
      flagsButtonPadding: const EdgeInsets.all(0),
      dropdownIconPosition: IconPosition.trailing,
      inputFormatters: formatters,
      keyboardType: TextInputType.number,
      style: MyTextStyle.f15(blackColor, weight: FontWeight.w400),
      cursorColor: appPrimaryColor,
      onChanged: (phone) {
        widget.onPhoneChanged(phone.completeNumber);
      },
      validator: widget.validator != null
          ? (phoneNumber) => widget.validator!(phoneNumber?.number)
          : null,
      onCountryChanged: (country) {
        final maxLen = countryMaxLengths[country.code] ?? 10;
        setState(() {
          formatters = [LengthLimitingTextInputFormatter(maxLen)];
        });
      },
    );
  }
}

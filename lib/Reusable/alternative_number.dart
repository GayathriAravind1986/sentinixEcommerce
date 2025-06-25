import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class AlternativePhoneField extends StatefulWidget {
  final Function(String completePhoneNumber) onPhoneChanged;
  final TextEditingController? controller;

  const AlternativePhoneField({
    super.key,
    required this.onPhoneChanged,
    this.controller,
  });

  @override
  State<AlternativePhoneField> createState() => _AlternativePhoneFieldState();
}

class _AlternativePhoneFieldState extends State<AlternativePhoneField> {
  List<TextInputFormatter> formatters = [LengthLimitingTextInputFormatter(10)];
  final FocusNode _focusNode = FocusNode();
  Color borderColor = Colors.grey.withOpacity(0.5); // Keeping original color

  final Map<String, int> countryMaxLengths = {
    'IN': 10,
    'US': 10,
    'AE': 9,
    'GB': 10,
    'AU': 9,
  };

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        borderColor = _focusNode.hasFocus ? appPrimaryColor : Colors.grey.withOpacity(0.5);
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 70, // Keeping original margins
      child: IntlPhoneField(
        focusNode: _focusNode,
        controller: widget.controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(6), // Keeping original padding
          labelText: 'Alternative Phone Number',
          labelStyle: MyTextStyle.f14(greyColor),
          floatingLabelStyle: TextStyle(color: appPrimaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Keeping original radius
            borderSide: BorderSide(color: borderColor, width: 1.5), // Keeping original width
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: appPrimaryColor, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white38, //
        ),
        initialCountryCode: 'IN',
        showCountryFlag: false,
        showDropdownIcon: false,
        flagsButtonMargin: const EdgeInsets.only(right: 0),
        flagsButtonPadding: const EdgeInsets.all(0),
        dropdownIconPosition: IconPosition.trailing,
        inputFormatters: formatters,
        keyboardType: TextInputType.number,
        style: MyTextStyle.f15(greyColor, weight: FontWeight.w400), // Keeping original text style
        cursorColor: appPrimaryColor,
        onChanged: (phone) {
          widget.onPhoneChanged(phone.completeNumber);
        },
        onCountryChanged: (country) {
          final maxLen = countryMaxLengths[country.code] ?? 10;
          setState(() {
            formatters = [LengthLimitingTextInputFormatter(maxLen)];
          });
        },
      ),
    );
  }
}
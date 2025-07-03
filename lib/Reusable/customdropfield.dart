import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 650;

    return DropdownButtonFormField2<T>(
      isExpanded: true,
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: isMobile
          ? MyTextStyle.f16(blackColor, weight: FontWeight.w500)
          : MyTextStyle.f20(blackColor, weight: FontWeight.w500),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        hintText: hint,
        hintStyle: isMobile
              ? MyTextStyle.f14(greyColor, weight: FontWeight.w500)
              : MyTextStyle.f18(greyColor, weight: FontWeight.w300),
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: appGreyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: appGreyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: appPrimaryColor),
        ),
      ),
      buttonStyleData: const ButtonStyleData(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 12),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(appPrimaryColor),
          radius: const Radius.circular(8),
        ),
        offset: const Offset(0, 2),
        elevation: 3,
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: appPrimaryColor),
      ),
      menuItemStyleData: MenuItemStyleData(
        selectedMenuItemBuilder: (context, child) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: appPrimaryColor.withOpacity(0.1),
          ),
          child: child,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

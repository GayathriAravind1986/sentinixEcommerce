import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class ProfileSectionTile extends StatefulWidget {
  final String title;
  final Widget child;
  final IconData icon;

  const ProfileSectionTile({
    super.key,
    required this.title,
    required this.child,
    required this.icon,
  });

  @override
  State<ProfileSectionTile> createState() => _ProfileSectionTileState();
}

class _ProfileSectionTileState extends State<ProfileSectionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: appSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: appPrimaryColor, width: 1.5),
      ),
      child: ExpansionTile(
        initiallyExpanded: _expanded,
        onExpansionChanged: (expanded) {
          setState(() => _expanded = expanded);
        },
        leading: Icon(widget.icon, color: appPrimaryColor),
        title: Text(
          widget.title,
          style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

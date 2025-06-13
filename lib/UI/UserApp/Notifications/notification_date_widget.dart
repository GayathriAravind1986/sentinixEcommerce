import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Notifications/notification_screen/notification_model.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Notifications/notification_screen/notification_tile.dart';


Widget _buildGroup(String title, List<NotificationItem> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006064),
          ),
        ),
      ),
      ...items.map((item) => NotificationTile(item: item)).toList(),
    ],
  );
}

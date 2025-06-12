import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_model.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Welcome!',
      message: 'Thanks for joining us!',
      timestamp: DateTime.now(),
    ),
    NotificationItem(
      title: 'Today Offer',
      message: 'Flash deal ends soon!',
      timestamp: DateTime.now(),
    ),
    NotificationItem(
      title: 'Reminder',
      message: 'Don’t forget your cart!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationItem(
      title: 'Weekly Update',
      message: 'Check out new arrivals.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NotificationItem(
      title: 'Discount Alert',
      message: 'Your 50% coupon expires soon!',
      timestamp: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  Future<void> _refreshNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      notifications.insert(
        0,
        NotificationItem(
          title: 'New Alert!',
          message: 'Buy 1 Get 1 offer live now.',
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _handleDelete(NotificationItem item) {
    setState(() {
      notifications.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Deleted: ${item.title}")),
    );
  }

  void _handleDeleteAll() {
    if (notifications.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete All Notifications?"),
        content: const Text("Are you sure you want to delete all notifications?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All notifications deleted")),
              );
            },
            child: const Text("Delete All"),
          ),
        ],
      ),
    );
  }

  Map<String, List<NotificationItem>> _groupNotifications(List<NotificationItem> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sevenDaysAgo = today.subtract(const Duration(days: 7));

    Map<String, List<NotificationItem>> grouped = {
      'Today': [],
      'Yesterday': [],
      'Last 7 Days': [],
    };

    for (var item in items) {
      final itemDate = DateTime(item.timestamp.year, item.timestamp.month, item.timestamp.day);
      if (itemDate == today) {
        grouped['Today']!.add(item);
      } else if (itemDate == yesterday) {
        grouped['Yesterday']!.add(item);
      } else if (itemDate.isAfter(sevenDaysAgo)) {
        grouped['Last 7 Days']!.add(item);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedItems = _groupNotifications(notifications);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.primaryContainer,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: MyTextStyle.f20(theme.colorScheme.onPrimaryContainer),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: notifications.isEmpty
            ? const Center(
          child: Text(
            "No notifications",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        )
            : ListView(
          children: groupedItems.entries.expand<Widget>((entry) {
            final title = entry.key;
            final items = entry.value;
            if (items.isEmpty) return [];

            return [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              ...items.map(
                    (item) => Dismissible(
                  key: ValueKey(item.timestamp.toIso8601String()),
                  confirmDismiss: (_) async {
                    return await showModalBottomSheet<bool>(
                      context: context,
                      builder: (_) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text("Delete this notification"),
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete_forever),
                            title: const Text("Delete all notifications"),
                            onTap: () {
                              Navigator.pop(context, false);
                              _handleDeleteAll();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(width: 10),
                        Icon(Icons.delete_forever, color: Colors.white),
                      ],
                    ),
                  ),
                  onDismissed: (_) => _handleDelete(item),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      child: const Icon(Icons.notifications, color: Colors.teal),
                    ),
                    title: Text(
                      item.title,
                      style: MyTextStyle.f14(theme.colorScheme.onSurface),
                    ),
                    subtitle: Text(item.message),
                    trailing: Text(
                      DateFormat('hh:mm a').format(item.timestamp),
                      style: MyTextStyle.f12(theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
            ];
          }).toList(),
        ),
      ),
    );
  }
}

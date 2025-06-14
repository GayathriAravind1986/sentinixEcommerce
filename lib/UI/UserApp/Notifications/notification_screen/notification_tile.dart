import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Notifications/notification_screen/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem item;

  const NotificationTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.title + item.timestamp.toIso8601String()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.delete, color: Color(0xFF006064)),
                  title: const Text('Delete this notification'),
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_sweep, color: Color(0xFF006064)),
                  title: const Text('Delete all notifications'),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete All'),
                        content: const Text('Are you sure you want to delete all notifications?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete All'),
                          ),
                        ],
                      ),
                    );
                    Navigator.of(context).pop(false); // Close bottom sheet
                    if (confirm == true) {
                      //context.read<NotificationBloc>().add(DeleteAllNotifications());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All notifications deleted')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ) ?? false;
      },
      onDismissed: (_) {
        //context.read<NotificationBloc>().add(DeleteNotification(item));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted: ${item.title}')),
        );
      },
      background: Container(
        color: const Color(0xFF1DE9B6),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: const Icon(Icons.notifications, color: Color(0xFF006064)),
          title: Text(item.title),
          subtitle: Text(item.title),
          trailing: Text(
            "${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

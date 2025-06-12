import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_model.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'app_theme.dart';
class NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final void Function(NotificationItem) onDeleteTap;
  final void Function() onDeleteAllTap;

  const NotificationTile({
    super.key,
    required this.item,
    required this.onDeleteTap,
    required this.onDeleteAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteColors = theme.extension<NotificationColors>()!;

    return Dismissible(
      key: Key(item.title + item.timestamp.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        _showDeleteOptions(context);
        return Future.value(false);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: theme.colorScheme.error,
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.colorScheme.surfaceVariant,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        elevation: 2,
        child: ListTile(
          leading: Badge(
            backgroundColor: noteColors.unreadDot,
            smallSize: 8.0,
            child: Icon(Icons.notifications_active, color: theme.colorScheme.primary),
          ),
          title: Text(
            item.title,
            style: MyTextStyle.f20(theme.colorScheme.onSurface),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.message,
                style: MyTextStyle.f16(theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('hh:mm a').format(item.timestamp),
                style: MyTextStyle.f12(theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteOptions(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete this notification'),
            onTap: () {
              onDeleteTap(item);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Delete all notifications'),
            onTap: () {
              onDeleteAllTap();
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}

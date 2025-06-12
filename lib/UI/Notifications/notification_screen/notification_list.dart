import 'package:flutter/material.dart';
import 'notification_model.dart';
import 'notification_tile.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationItem> items;
  final ValueChanged<NotificationItem> onDeleteTap;
  final VoidCallback onDeleteAllTap;
  final RefreshCallback onRefresh;

  const NotificationList({
    super.key,
    required this.items,
    required this.onDeleteTap,
    required this.onDeleteAllTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = _getGrouped(items);
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: theme.colorScheme.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        children: items.isEmpty
            ? [
          SizedBox(
            height: MediaQuery.of(context).size.height * .7,
            child: Center(
              child: Text(
                'No notifications',
                style: MyTextStyle.f18(
                  theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        ]
            : [
          for (final section in ['Today', 'Yesterday', 'Last 7 Days'])
            if ((grouped[section]?.isNotEmpty ?? false)) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  section,
                  style: MyTextStyle.f16(
                      theme.colorScheme.onSurfaceVariant)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ...grouped[section]!.map(
                    (item) => NotificationTile(
                  item: item,
                  onDeleteTap: onDeleteTap,
                  onDeleteAllTap: onDeleteAllTap,
                ),
              ),
            ]
        ],
      ),
    );
  }

  Map<String, List<NotificationItem>> _getGrouped(List<NotificationItem> list) {
    final now = DateTime.now();
    final today = list.where((n) => _sameDay(n.timestamp, now)).toList();
    final yesterday = list
        .where((n) =>
        _sameDay(n.timestamp, now.subtract(const Duration(days: 1))))
        .toList();
    final last7 = list
        .where((n) =>
    n.timestamp.isAfter(now.subtract(const Duration(days: 7))) &&
        !today.contains(n) &&
        !yesterday.contains(n))
        .toList();

    return {
      'Today': today,
      'Yesterday': yesterday,
      'Last 7 Days': last7,
    };
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

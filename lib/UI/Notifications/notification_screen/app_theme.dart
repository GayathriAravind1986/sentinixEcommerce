// app_theme.dart

import 'package:flutter/material.dart';

@immutable
class NotificationColors extends ThemeExtension<NotificationColors> {
  final Color badge;
  final Color unreadDot;

  const NotificationColors({required this.badge, required this.unreadDot});

  @override
  NotificationColors copyWith({Color? badge, Color? unreadDot}) => NotificationColors(
    badge: badge ?? this.badge,
    unreadDot: unreadDot ?? this.unreadDot,
  );

  @override
  NotificationColors lerp(ThemeExtension<NotificationColors>? other, double t) {
    if (other is! NotificationColors) return this;
    return NotificationColors(
      badge: Color.lerp(badge, other.badge, t)!,
      unreadDot: Color.lerp(unreadDot, other.unreadDot, t)!,
    );
  }
}

class AppTheme {
  static const primaryColor = Color(0xFF1DE9B6);
  static const secondaryColor = Color(0xFF006064);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      brightness: Brightness.light,
    ),
    extensions: <ThemeExtension<dynamic>>[
      const NotificationColors(badge: Color(0xFFE53935), unreadDot: Color(0xFF1E88E5)),
    ],
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      brightness: Brightness.dark,
    ),
    extensions: <ThemeExtension<dynamic>>[
      const NotificationColors(badge: Color(0xFFEF9A9A), unreadDot: Color(0xFF90CAF9)),
    ],
  );
}

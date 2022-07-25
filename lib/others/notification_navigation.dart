import 'package:flutter/material.dart';

import 'notification_payload.dart';

abstract class NotificationNavigation {
  void navigateTo(NotificationPayload payload);
}

class DefaultNotificationNavigation implements NotificationNavigation {
  final GlobalKey<NavigatorState> navigatorKey;

  DefaultNotificationNavigation({required this.navigatorKey});

  @override
  void navigateTo(NotificationPayload payload) {
    payload.trigger(navigatorKey.currentContext!);
  }
}

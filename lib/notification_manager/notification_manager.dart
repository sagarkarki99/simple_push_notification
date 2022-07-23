import 'package:flutter/material.dart';

abstract class NotificationManager {
  ///displays notification pop in ui when user is using the app
  Future<void> displayPopup(
      String title,
      String body,
      Map<String, dynamic> message,
      Function(Map<String, dynamic>) onReadNotification);

  /// navigates user according to the payload in [message]
  void navigate(Map<String, dynamic> message);

  /// a listener which listens to changes when a push notification arrives when app is active state.
  void onNotificationRead(VoidCallback onNotificationRead);
}

library simple_push_notification;

import 'package:flutter/material.dart';
import 'package:simple_push_notification/notification_manager/notification_manager.dart';
import 'package:simple_push_notification/notification_manager/notification_manager_impl.dart';
import 'package:simple_push_notification/others/notification_config.dart';
import 'package:simple_push_notification/others/notification_navigation.dart';
import 'package:simple_push_notification/others/notification_payload.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_push_notification/push_notification/push_notification_service.dart';
import 'package:simple_push_notification/push_notification/push_notification_service_impl.dart';

export 'notification_manager/notification_manager.dart';
export 'others/notification_config.dart';
export 'others/notification_navigation.dart';
export 'others/notification_payload.dart';

class SimplePushNotification {
  late final InternalPushNotification pushNotification;

  late final NotificationNavigation nav;
  late final NotificationManager _manager;
  static late SimplePushNotification _instance;

  SimplePushNotification._internal({
    required this.nav,
    required NotificationPayload Function(Map<String, dynamic>)
        getNotificationPayload,
    required NotificationConfig config,
  }) {
    _manager = NotificationManagerImpl(
      notificationClient: FlutterLocalNotificationsPlugin(),
      config: config,
      notificationNavigation: nav,
      getNotificationPayload: getNotificationPayload,
    );
    pushNotification = InternalPushNotificationImpl(
      _manager,
      null,
    );
  }

  /// Initialize push notification inorder to `activate` `deactivate` or `listen` to push notification service.
  ///
  /// Inorder to handle notification navigation, either
  ///  you need to implement [NotificationNavigation] interface and pass it here.
  /// or,
  ///
  /// pass a navigator key of type [GlobalKey<NavigatorState>] that is passed in MaterialApp's navigatorKey.
  ///
  /// Create a class implementing [NotificationPayload] and return it from this callback.
  /// This will navigate to routes specified in Payload
  /// `Map<String,dynamic>` is a data coming from push notification.

  /// Config includes the notification channel id, name and description, specifically for android.
  static SimplePushNotification initialize({
    NotificationNavigation? nav,
    GlobalKey<NavigatorState> Function()? navigatorKey,
    required NotificationPayload Function(Map<String, dynamic>)
        getNotificationPayload,
    required NotificationConfig config,
  }) {
    assert(nav != null || navigatorKey != null,
        'Either `navigatorKey` or class implementing NotificationNavigation should be available ');
    _instance = SimplePushNotification._internal(
      nav: nav ??
          DefaultNotificationNavigation(
            navigatorKey: navigatorKey!(),
          ),
      getNotificationPayload: getNotificationPayload,
      config: config,
    );
    return _instance;
  }

  static SimplePushNotification get instance => _instance;
  NotificationManager get notificationManager => _manager;

  /// This method activates the service and starts recieving push notification from firebase.
  ///
  ///
  /// `onRead` is called when a popup notification is tapped
  /// `onActivated` is called when push notification is activated successfully.
  Future<void> activate({
    required void Function(Map<String, dynamic>) onRead,
    required void Function(String?) onActivated,
  }) async {
    await pushNotification.activate(
      onRead: onRead,
      onActivated: onActivated,
    );
  }

  /// This method deactivates and stops recieving push notifications.
  ///
  ///
  /// `onDeactivated` is called when push notification is deactivated successfully.
  Future<void> deactivate({
    required void Function(String?) onDeactivated,
  }) async {
    await pushNotification.deactivate(
      onDeactivated: onDeactivated,
    );
  }

  /// This methods listens to push notifications.
  /// When any notifications arrives, `notify` callback is called.
  void listen(Function(Map<String, dynamic>) notify) {
    pushNotification.listen(notify);
  }
}

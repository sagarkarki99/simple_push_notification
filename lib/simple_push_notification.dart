library classroom_push_notification;

import 'package:simple_push_notification/notification_manager/notification_manager.dart';
import 'package:simple_push_notification/notification_manager/notification_manager_impl.dart';
import 'package:simple_push_notification/others/notification_config.dart';
import 'package:simple_push_notification/others/notification_navigation.dart';
import 'package:simple_push_notification/others/notification_payload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_push_notification/push_notification/push_notification_service.dart';
import 'package:simple_push_notification/push_notification/push_notification_service_impl.dart';

class ClassroomPushNotification {
  late final InternalPushNotification pushNotification;
  late final FirebaseApp firebaseApp;
  late final NotificationNavigation nav;
  late final NotificationManager _manager;
  static late ClassroomPushNotification _instance;

  ClassroomPushNotification._internal({
    required this.firebaseApp,
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

  static ClassroomPushNotification initialize(
    FirebaseApp firebaseApp,
    NotificationNavigation nav,
    NotificationPayload Function(Map<String, dynamic>) getNotificationPayload, {
    required NotificationConfig config,
  }) {
    _instance = ClassroomPushNotification._internal(
      firebaseApp: firebaseApp,
      nav: nav,
      getNotificationPayload: getNotificationPayload,
      config: config,
    );
    return _instance;
  }

  static ClassroomPushNotification get instance => _instance;
  NotificationManager get notificationManager => _manager;

  Future<void> activate({
    required void Function(String) onRead,
    required void Function(String?) onActivated,
  }) async {
    await pushNotification.activate(
      onRead: onRead,
      onActivated: onActivated,
    );
  }

  Future<void> deactivate({
    required void Function(String?) onDeactivated,
  }) async {
    await pushNotification.deactivate(
      onDeactivated: onDeactivated,
    );
  }

  void listen(Function(Map<String, dynamic>) callback) {
    pushNotification.listen(callback);
  }
}

library simple_push_notification;

import 'package:simple_push_notification/notification_manager/notification_manager.dart';
import 'package:simple_push_notification/notification_manager/notification_manager_impl.dart';
import 'package:simple_push_notification/others/notification_config.dart';
import 'package:simple_push_notification/others/notification_navigation.dart';
import 'package:simple_push_notification/others/notification_payload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_push_notification/push_notification/push_notification_service.dart';
import 'package:simple_push_notification/push_notification/push_notification_service_impl.dart';

class SimplePushNotification {
  late final InternalPushNotification pushNotification;
  late final FirebaseApp firebaseApp;
  late final NotificationNavigation nav;
  late final NotificationManager _manager;
  static late SimplePushNotification _instance;

  SimplePushNotification._internal({
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

  /// Initialize push notification inorder to `activate` `deactivate` or `listen` to push notification service.
  static SimplePushNotification initialize(
    FirebaseApp firebaseApp,

    /// Inorder to handle notification navigation, you need to implement [NotificationNavigation] interface and pass it here.
    ///
    /// ``` dart
    /// class NavigationHandler implements NotificationNavigation{
    /// @override
    /// void navigateTo(NotificationPayload payload) {
    ///   ///handle navigation to which ever router you have.
    ///   payload.trigger(context); /// pass the context of `Navigator` in here.
    ///  }
    ///}
    ///  ```
    NotificationNavigation nav,

    /// Create a class implementing [NotificationPayload] and return it from this callback.
    /// This will navigate to routes specified in Payload
    /// `Map<String,dynamic>` is a data coming from push notification.
    NotificationPayload Function(Map<String, dynamic>) getNotificationPayload, {

    /// Config includes the notification channel id, name and description, specifically for android.
    required NotificationConfig config,
  }) {
    _instance = SimplePushNotification._internal(
      firebaseApp: firebaseApp,
      nav: nav,
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
    required void Function(String) onRead,
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
  /// `onRead` is called when a popup notification is tapped
  /// `onActivated` is called when push notification is activated successfully.
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

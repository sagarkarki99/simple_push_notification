import 'dart:io';

import 'package:simple_push_notification/notification_manager/notification_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:simple_push_notification/push_notification/push_notification_service.dart';

class InternalPushNotificationImpl implements InternalPushNotification {
  final NotificationManager notificationManager;
  final String? previousToken;

  late Function(String) _onReadNotification;
  final List<Function(Map<String, dynamic>)> _listeners = [];

  InternalPushNotificationImpl(
    this.notificationManager,
    this.previousToken,
  );
  @override
  Future<void> activate({
    required void Function(String) onRead,
    required void Function(String?) onActivated,
  }) async {
    _onReadNotification = onRead;
    await _activateForiOS();
    if (previousToken == null) {
      final String? fcmToken = await FirebaseMessaging.instance.getToken();
      onActivated(fcmToken);
    }
    //when app is started from terminated state
    final RemoteMessage? notificationStackMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (notificationStackMessage != null) {
      Future.delayed(const Duration(seconds: 1), () {
        _navigateToLocalNavigation(notificationStackMessage.data);
      });
    }

    //while app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = {
        ...message.data,
        'body': message.data['message'] ?? message.notification?.body,
        'secondaryTitle': message.data['title'] ?? message.notification?.title,
        'date': message.sentTime?.millisecondsSinceEpoch,
        'time': message.sentTime?.millisecondsSinceEpoch,
      };
      _notifyListeners(data);
      notificationManager.displayPopup(
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        data,
        (String id) => markNotificationAsRead(id),
      );
    });

    //while app is in background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final data = {
        ...message.data,
        'body': message.data['message'] ?? message.notification?.body,
        'secondaryTitle': message.data['title'] ?? message.notification?.title,
        'date': message.sentTime?.millisecondsSinceEpoch,
        'time': message.sentTime?.millisecondsSinceEpoch,
      };
      _navigateToLocalNavigation(data);
    });
  }

  @override
  Future<void> deactivate({required Function(String) onDeactivated}) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await FirebaseMessaging.instance.deleteToken();
    onDeactivated(fcmToken ?? '');
  }

  @override
  void listen(Function(Map<String, dynamic>) callback) {
    _listeners.add(callback);
  }

  Future<void> _activateForiOS() async {
    if (Platform.isIOS) await FirebaseMessaging.instance.requestPermission();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _navigateToLocalNavigation(Map<String, dynamic> data) {
    markNotificationAsRead(data['messageId'] as String);
    notificationManager.navigate(data);
  }

  void markNotificationAsRead(String messageId) {
    _onReadNotification(messageId);
  }

  void _notifyListeners(Map<String, dynamic> data) {
    for (var listener in _listeners) {
      listener(data);
    }
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:simple_push_notification/others/notification_config.dart';
import 'package:simple_push_notification/others/notification_navigation.dart';
import 'package:simple_push_notification/others/notification_payload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_manager.dart';

Map<String, dynamic> _foregroundMessage = {};
late Function(Map<String, dynamic>) _onNotificationClick;

class NotificationManagerImpl implements NotificationManager {
  final FlutterLocalNotificationsPlugin notificationClient;
  final NotificationNavigation notificationNavigation;
  VoidCallback? notificationRead;
  NotificationPayload Function(Map<String, dynamic>) getNotificationPayload;
  final NotificationConfig config;

  NotificationManagerImpl({
    required this.notificationClient,
    required this.notificationNavigation,
    required this.getNotificationPayload,
    required this.config,
  }) {
    _init();
  }

  @override
  Future<void> displayPopup(
      String title,
      String body,
      Map<String, dynamic> message,
      Function(Map<String, dynamic> payload) onReadNotification) async {
    _onNotificationClick = onReadNotification;
    _foregroundMessage = message;
    if (Platform.isAndroid) await _displayNotification(title, body, message);
  }

  @override
  void navigate(Map<String, dynamic> message) {
    _handleNotificationNavigation(message);
  }

  Future<void> _init() async {
    if (Platform.isIOS) {
      _requestIosPermission();
    }

    final initializationSettings = InitializationSettings(
      android: _getAndroidSettings(),
      iOS: _getIosSettings(),
    );

    await notificationClient
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    await notificationClient.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async =>
          _openNotification(_foregroundMessage),
    );
  }

  AndroidInitializationSettings _getAndroidSettings() =>
      AndroidInitializationSettings(config.appIcon);

  DarwinInitializationSettings _getIosSettings() =>
      const DarwinInitializationSettings();

  void _requestIosPermission() {
    if (notificationClient.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>() !=
        null) {
      notificationClient
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(
            alert: true,
            badge: true,
          );
    }
  }

  void _openNotification(Map<String, dynamic> data) {
    _onNotificationClick(data);
    _handleNotificationNavigation(_foregroundMessage);
  }

  Future<void> _displayNotification(
      String title, String body, Map<String, dynamic> message) async {
    final androidDetails = _getAndroidNotificationDetail();
    final iosDetails = _getIosNotificationDetails();

    final notificationDetail = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await notificationClient.show(
      0,
      title,
      body,
      notificationDetail,
      payload: message.toString(),
    );
  }

  void _handleNotificationNavigation(Map<String, dynamic> message) {
    notificationRead?.call();
    final payload = _getNotificationPayload(message);
    notificationNavigation.navigateTo(payload);
  }

  AndroidNotificationDetails _getAndroidNotificationDetail() =>
      AndroidNotificationDetails(
        config.notificationChannelId,
        config.notificationChannelName,
        importance: Importance.high,
        priority: Priority.high,
      );

  AndroidNotificationChannel get _androidChannel => AndroidNotificationChannel(
        config.notificationChannelId,
        config.notificationChannelName,
        importance: Importance.high,
      );

  DarwinNotificationDetails _getIosNotificationDetails() =>
      const DarwinNotificationDetails();

  NotificationPayload _getNotificationPayload(Map<String, dynamic> message) {
    log(message.toString());
    return getNotificationPayload(message);
  }

  @override
  void onNotificationRead(VoidCallback onNotificationRead) {
    notificationRead = onNotificationRead;
  }
}

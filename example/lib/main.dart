import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notification_demo/firebase_options.dart';
import 'package:notification_demo/payloads.dart';
import 'package:simple_push_notification/simple_push_notification.dart';

// Pass this navigatorKey using dependency Injection like get_it package.
final navigatorKey = GlobalKey<NavigatorState>();
late SimplePushNotification pushNotification;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Notification_demo',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  pushNotification = SimplePushNotification.initialize(
    navigatorKey: () => navigatorKey,
    getNotificationPayload: (map) => getPayload(map),
    config: NotificationConfig(
        appIcon: 'ic_launcher',
        notificationChannelDescription: 'this is a test description',
        notificationChannelId: 'testId',
        notificationChannelName: 'Test name'),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await pushNotification.activate(
                  onActivated: (token) {
                    log('NOtification activated!!!! token: $token');
                  },
                  onRead: (payload) {
                    log(payload.toString());
                  },
                );
              },
              child: const Text('Activate Push Notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await pushNotification.deactivate(
                  onDeactivated: (token) {
                    log('NOtification deactivated!!!! token: $token');
                  },
                );
              },
              child: const Text('Deactivate Push Notification'),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

NotificationPayload getPayload(Map<String, dynamic> data) {
  final type = data['notificationType'] as String;
  switch (type) {
    case 'cart':
      return CartPayload(data['cartId']);

    case 'payment':
      return PaymentPayload(data['paymentId']);
    case 'checkout':
      return CheckoutPayload();

    default:
      return DefaultPayload();
  }
}

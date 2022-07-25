A simple notification package for handling firebase notifications which supports notification navigations.

## Features

- Display push notification
- activate and deactivate the push notification service
- navigate to desired screen, view or page after tapping to push notification popup

## Getting started

In the pubspec.yaml of your flutter project, add the following dependency:

```dart
    dependencies:
        simple_push_notification: latest_version_number
```

import it:

```dart
    import 'package:simple_push_notification/simple_push_notification.dart';
```

Inorder to use this package properly, firebase app should be configured properly in your flutter app. It will be easier using `Flutterfire`. Follow this [doc](https://firebase.flutter.dev/docs/cli/)

### Android

After configuring firebase, you will see `firebase_options.dart` created in your lib folder. All you need to do is start a firebase app and use `SimplePushNotification` class.

```dart
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: NAME_OF_YOUR_FIREBASE_APP,
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App());
}
```

After the initialization, use `SimplePushNotification` class anyway you desire.

## Usage

```dart
    final pushNotification = SimplePushNotification.initialize(
    navigatorKey: () => navigatorKey,
    getNotificationPayload: (map) => SimplePayload(),
    config: NotificationConfig(
        appIcon: 'ic_launcher',
        notificationChannelDescription: 'this is a test description',
        notificationChannelId: 'testId',
        notificationChannelName: 'Test name'),
  );

  await pushNotification.activate(
    onActivated: (token) {
      log('Notification activated!!!! token: $token');
    },
    onRead: (payload) {
      log(payload.toString());
    },
  );

```

here, `navigatorKey` must be provided same as in MaterialApp's navigatorKey or a class that implements `NotificationNavigation`.

## Information

Please feel free to create PR if you want to contributte.

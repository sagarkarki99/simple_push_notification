typedef PayloadCallback = void Function(Map<String, dynamic>);

abstract class InternalPushNotification {
  ///activate remote push notification service when user is authenticated
  Future<void> activate({
    required void Function(Map<String, dynamic>) onRead,
    required void Function(String?) onActivated,
  });

  ///deactivate remote push notification service when user is unauthenticated
  Future<void> deactivate({required Function(String) onDeactivated});

  /// Add a listener which listens to changes when a push notification arrives when app is active state.
  void addListener(PayloadCallback listener);

  /// Remove a previously added listener.
  void removeListener(PayloadCallback listener);
}

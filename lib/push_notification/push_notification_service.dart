abstract class InternalPushNotification {
  ///activate remote push notification service when user is authenticated
  Future<void> activate({
    required void Function(String) onRead,
    required void Function(String?) onActivated,
  });

  ///deactivate remote push notification service when user is unauthenticated
  Future<void> deactivate({required Function(String) onDeactivated});

  /// a listener which listens to changes when a push notification arrives when app is active state.
  void listen(Function(Map<String, dynamic>) callback);
}

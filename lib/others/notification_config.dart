class NotificationConfig {
  final String appIcon;
  final String notificationChannelId;
  final String notificationChannelName;
  final String notificationChannelDescription;

  NotificationConfig({
    /// Pass the name of the icon to show in notification popup. This icon should be inside `@drawable/` in android folder.
    required this.appIcon,
    required this.notificationChannelId,
    required this.notificationChannelName,
    required this.notificationChannelDescription,
  });
}

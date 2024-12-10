class NotificationEntity {
  final String id;
  final String message;
  final bool isRead;
  final DateTime localTimestamp;
  final String userId;

  NotificationEntity({
    required this.id,
    required this.message,
    required this.isRead,
    required this.localTimestamp,
    required this.userId,
  });
}

class NotificationEntity {
  final String id;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final String userId;

  NotificationEntity({
    required this.id,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.userId,
  });
}

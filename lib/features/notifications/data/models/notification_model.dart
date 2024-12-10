import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.message,
    required super.isRead,
    required super.userId,
    required super.localTimestamp,
  });

  // From JSON (to convert API response to a model)
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      message: json['message'],
      isRead: json['isRead'],
      // createdAt: DateTime.parse(json['createdAt']),
      userId: json['user_id'], localTimestamp: DateTime.now(),
    );
  }

  // To JSON (to convert model to API format)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'message': message,
      'isRead': isRead,
      // 'createdAt': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }

  // To Entity{
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      message: message,
      isRead: isRead,
      userId: userId,
      localTimestamp: localTimestamp,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/features/notifications/domain/entities/notification_entity.dart';

import '../../../../core/resources/generic_state.dart';
import '../bloc/notification_cubit.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, GenericState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.isSuccess) {
          // Sort notifications: Unread first, then by creation date if available
          final List<NotificationEntity> notifications = state.data!;
          notifications.sort((a, b) {
            return a.isRead ? 1 : -1; // Unread comes first
          });

          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final NotificationEntity notification = notifications[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Leading Icon
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: notification.isRead
                            ? Colors.grey[300]
                            : Colors.blue[100],
                        child: Icon(
                          notification.isRead
                              ? Icons.notifications_none
                              : Icons.notifications_active,
                          color: notification.isRead
                              ? Colors.grey[600]
                              : Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Notification Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.message,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "notification",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Mark as Read Icon
                      if (!notification.isRead)
                        IconButton(
                          icon: const Icon(Icons.mark_email_read_rounded),
                          color: Colors.blue,
                          onPressed: () {
                            context
                                .read<NotificationCubit>()
                                .markAsRead(notification.id);
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('Failed to load notifications.'));
        }
      },
    );
  }
}

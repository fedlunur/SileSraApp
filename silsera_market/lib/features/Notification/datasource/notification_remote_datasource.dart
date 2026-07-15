import 'dart:async';
import 'package:dio/dio.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/features/POST/BaseService.dart';

abstract class NotificationRemoteDatasource {
  Future<List<NotificationResponse>> getNotifications();
  Future<void> deleteNotification(int notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDatasource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationResponse>> getNotifications() async {
    BaseService bs = BaseService("notification");

    // Call the fetchNotificationItems method
    final chatMessages = await bs.fetchNotificationItems();
    print("%%%%  Notification list for user is inside remote  $chatMessages");
    // Map the result to NotificationResponse using fromDict
    final notifications = chatMessages.map((chatMessage) {
      return NotificationResponse.fromDict({
        'id': chatMessage.id,
        'objectId': chatMessage.objectId,
        'message': chatMessage.message,
        'approvalStatus': chatMessage.approvalStatus,
        'user': {
          'id': chatMessage.user?.id,
          'name': chatMessage.user?.name,
        },
        'contentType': chatMessage.contentType,
        'created': chatMessage.created,
      });
    }).toList();

    return notifications;
  }

  @override
  Future<void> deleteNotification(int notificationId) async {
    // Implement the logic to delete a notification
    // Example:
    final response = await dio.delete('/notifications/$notificationId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete notification');
    }
  }

 
}

import 'package:silesra/core/config/MiscillaniousModels.dart';

abstract class NotificationRepository {
  Future<List<NotificationResponse>> getNotifications();
  Future<void> deleteNotification(int notificationId);
}

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<NotificationResponse>> call() async {
    return await repository.getNotifications();
  }
}

class DeleteNotification {
  final NotificationRepository repository;

  DeleteNotification(this.repository);

  Future<void> call(int notificationId) async {
    return await repository.deleteNotification(notificationId);
  }
}

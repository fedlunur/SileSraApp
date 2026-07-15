import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/features/Notification/datasource/notification_remote_datasource.dart';
import 'package:silesra/features/Notification/domain/usecases/notification_usecases.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource remoteDataSource;
  
  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationResponse>> getNotifications() async {
    return await remoteDataSource.getNotifications();
  }

  @override
  Future<void> deleteNotification(int notificationId) async {
    return await remoteDataSource.deleteNotification(notificationId);
  }
}

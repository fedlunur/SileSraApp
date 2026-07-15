import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/features/Notification/domain/usecases/notification_usecases.dart';
import 'package:silesra/features/POST/ListingProvider.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications getNotificationsUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
  }) : super(NotificationInitial()) {
    on<NotificationFetchEvent>(_onNotificationFetchEvent);
    on<NotificationDeleteEvent>(_onNotificationDeleteEvent);
  }

  Future<void> _onNotificationFetchEvent(
      NotificationFetchEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final accUse = await getNotificationsUseCase();
      emit(NotificationLoaded(accUse));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onNotificationDeleteEvent(
      NotificationDeleteEvent event, Emitter<NotificationState> emit) async {
    try {
       print("%%%%   Deletion is called  Context Read is done for ===>  ${event.notificationId}");
      final userService = ListingProvider().userService;
      userService.delete('notification', event.notificationId);
      final notifications = await getNotificationsUseCase();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}

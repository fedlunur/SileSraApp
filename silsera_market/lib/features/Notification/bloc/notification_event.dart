part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationFetchEvent extends NotificationEvent {}

class NotificationDeleteEvent extends NotificationEvent {
  final int notificationId;

  const NotificationDeleteEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
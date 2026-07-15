import 'package:equatable/equatable.dart';
import 'package:silesra/features/Auth/models/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {} // Initial state

class UserLoading extends UserState {} // Loading state

class UserLoaded extends UserState {
  final User user;
  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
} // State when user data is loaded

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object?> get props => [message];
} // State when an error occurs

class UserLoggedOut extends UserState {} // State when user is logged out

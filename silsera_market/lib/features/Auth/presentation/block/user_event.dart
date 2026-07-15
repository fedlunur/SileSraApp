import 'package:equatable/equatable.dart';
import 'package:silesra/features/Auth/models/user_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {}

class SignIn extends UserEvent {
  final String phone;
  final String password;

  const SignIn({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

class ChangePassword extends UserEvent {
  final String oldpassword;
  final String newpassword;
  final String confrimpassword;
  final User curuser;

  const ChangePassword({
    required this.oldpassword,
    required this.newpassword,
    required this.confrimpassword,
    required this.curuser,
  });

  @override
  List<Object?> get props => [oldpassword, newpassword, confrimpassword];
}

class SignUp extends UserEvent {
  final String name;
  final String fatherName;
  final String phone;
  final String password;
  final String confirmPassword;

  const SignUp(
      {required this.name,
      required this.fatherName,
      required this.phone,
      required this.password,
      required this.confirmPassword});

  @override
  List<Object?> get props =>
      [name, fatherName, phone, password, confirmPassword];
}

class RefreshToken extends UserEvent {}

class LogoutUser extends UserEvent {}

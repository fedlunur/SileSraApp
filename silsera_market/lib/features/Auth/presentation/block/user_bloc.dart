import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:silesra/core/config/user_auth_data.dart';
import 'package:silesra/features/Auth/models/user_model.dart';

import 'package:silesra/features/Auth/presentation/block/user_event.dart';
import 'package:silesra/features/Auth/presentation/block/user_state.dart';
import 'package:silesra/features/POST/ListingProvider.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<SignIn>(_onSignIn); // Handle SignIn event
    on<LoadUser>(_onLoadUser);
    on<RefreshToken>(_onRefreshToken);
    on<LogoutUser>(_onLogoutUser);
    on<SignUp>(_onSignUp);
    on<ChangePassword>(_onchangePassword);
  }
  Future<void> _onSignIn(SignIn event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      final userService = ListingProvider().userService;
      final formData = {
        "phone": event.phone,
        "password": event.password,
      };
      print(" -----> Ready to call API");
      final response =
          await userService.createUser(formData, User.fromMap, 'login');
      print(" -----> API Response: $response");

      if (response['success'] == true) {
        final user = User.fromMap(response['result']);
        await SharedPreferenceHelper.saveUser(
          user,
          accessToken: user.accessToken,
          refreshToken: user.refreshToken,
        );
        emit(UserLoaded(user));
      } else {
        final message =
            response['message'] ?? 'Login failed. Please try again.';
        emit(UserError(message));
      }
    } catch (e) {
      print(" -----> Error in _onSignIn: $e");
      if (e is DioException) {
        // Handle Dio-specific errors
        final statusCode = e.response?.statusCode;
        final errorMessage = e.response?.data?['message'] ?? e.message;

        if (statusCode == 401) {
          emit(const UserError('Incorrect phone number or password.'));
        } else if (statusCode == 404) {
          emit(const UserError('User not found.'));
        } else if (statusCode == 500) {
          emit(const UserError('Server error. Please try again later.'));
        } else {
          emit(UserError('Error: $errorMessage'));
        }
      } else {
        // Handle generic errors
        emit(UserError('Error: Please check your network. ${e.toString()}'));
      }
    }
  }

  Future<void> _onSignUp(SignUp event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      final userService = ListingProvider().userService;
      // Simulate API call

      final formData = {
        "first_name": event.name,
        "middle_name": event.fatherName,
        "phone": event.phone,
        "password": event.password,
        "password2": event.confirmPassword,
      };

      final response =
          await userService.createUser(formData, User.fromMap, 'register');

      if (response['success'] == true) {
        final user = User.fromMap(response['result']);

        await SharedPreferenceHelper.saveUser(
          user,
          accessToken: user.accessToken,
          refreshToken: user.refreshToken,
        );
        emit(UserLoaded(user));
      } else {
        emit(const UserError('Sign Up failed. Please try again.'));
      }
    } catch (e) {
      emit(UserError('Error: $e'));
    }
  }

  Future<void> _onchangePassword(
      ChangePassword event, Emitter<UserState> emit) async {
    emit(UserLoading());
    print("Change password is called but nothing seen ");

    try {
      final userService = ListingProvider().userService;
      final formData = {
        "old_password": event.oldpassword,
        "new_password": event.newpassword,
        "confirm_password": event.confrimpassword,
      };

      final response =
          await userService.changePassword(formData, 'changepassword');

      if (response['success'] == true) {
        print("Password changed successfully!");

        await SharedPreferenceHelper.clearUser();
        emit(UserLoggedOut());
      } else {
        final message = response['message'] ?? 'Password change failed.';

        if (message.contains("incorrect old password")) {
          emit(const UserError(
              "The old password you entered is incorrect. Please try again."));
        } else {
          emit(UserError(message));
        }
      }
    } catch (e) {
      print(" -----> Error in _onchangePassword: $e");

      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final errorMessage = e.response?.data?['message'] ?? e.message;

        if (statusCode == 400 && errorMessage.contains("old password")) {
          emit(const UserError("The old password you entered is incorrect."));
        } else if (statusCode == 401) {
          emit(const UserError("Unauthorized request. Please log in again."));
        } else if (statusCode == 404) {
          emit(const UserError("User not found."));
        } else if (statusCode == 500) {
          emit(const UserError("Server error. Please try again later."));
        } else {
          emit(UserError("Error: $errorMessage"));
        }
      } else {
        emit(UserError("Error: Please check your network. ${e.toString()}"));
      }
    }
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    

    try {
      // Fetch user data
      final user = await SharedPreferenceHelper.getUser();
      if (user == null) {
       
        emit(const UserError('No user data found.'));
        return;
      }

      // Check if the access token is valid
      final accessToken = await SharedPreferenceHelper.getValidAccessToken();
      if (accessToken == null) {
        print("======> Access token expired, attempting to refresh");
        final refreshedToken =
            await SharedPreferenceHelper.refreshAccessToken();
        if (refreshedToken == null) {
          print("======> Token refresh failed");
          emit(const UserError('Token expired. Please log in again.'));
          return;
        }
      }

      print("======> User loaded successfully");
      emit(UserLoaded(user));
    } catch (e) {
      print("======> Error loading user: $e");
      emit(UserError('Error: $e'));
    }
  }

  Future<void> _onRefreshToken(
      RefreshToken event, Emitter<UserState> emit) async {
    try {
      final accessToken = await SharedPreferenceHelper.refreshAccessToken();
      if (accessToken == null) {
        emit(const UserError('Failed to refresh token. Please log in again.'));
        return;
      }

      // Fetch user data again after refreshing the token
      add(LoadUser());
    } catch (e) {
      emit(UserError('Error: $e'));
    }
  }

  Future<void> _onLogoutUser(LogoutUser event, Emitter<UserState> emit) async {
    await SharedPreferenceHelper.clearUser();
    emit(UserLoggedOut());
  }
}

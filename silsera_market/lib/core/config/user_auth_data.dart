import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:silesra/core/config/settings.dart';
import 'package:silesra/features/Auth/models/user_model.dart';

class SharedPreferenceHelper {
  static const String _userKey = 'userData';
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  // Save user data to SharedPreferences
  static Future<void> saveUser(User user,
      {required String accessToken, required String refreshToken}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await clearUser(); // Clear old data before saving new

    await prefs.setString(_userKey, jsonEncode(user.toMap()));
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  // Retrieve user data from SharedPreferences
  static Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString(_userKey);
    if (userData != null) {
      Map<String, dynamic> userMap = jsonDecode(userData);
      return User.fromMap(userMap);
    }
    return null;
  }

  // Retrieve access token
  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Retrieve refresh token
  static Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Update access token when refreshed
  static Future<void> updateAccessToken(String newAccessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, newAccessToken);
  }

  // Clear user data from SharedPreferences (logout)
  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  // Automatically get a valid access token (refresh if expired)
  static Future<String?> getValidAccessToken() async {
    String? accessToken = await getAccessToken();

    if (accessToken != null && !isTokenExpired(accessToken)) {
      return accessToken;
    }

    // Access token expired, try refreshing it
    return await refreshAccessToken();
  }

  static bool isTokenExpired(String token) {
    return false; // Replace with real expiry check
  }

  static Future<String?> refreshAccessToken() async {
    String? refreshToken = await getRefreshToken();
    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse('$baseUrl/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final newAccessToken = responseData['access'];

      // Save the new access token
      await updateAccessToken(newAccessToken);
      return newAccessToken;
    } else {
      // Refresh token failed, log out user
      await handleTokenRefreshFailure();
      return null;
    }
  }

  static Future<void> handleTokenRefreshFailure() async {
    await clearUser();
    // TODO: Navigate user to login screen
  }

  // Centralized fetch user data with error handling
  static Future<Map<String, dynamic>> fetchUserData() async {
    try {
      User? user = await getUser();
      if (user == null) {
        return {
          'isLoading': false,
          'errorMessage': 'No user data found.',
          'user': null,
        };
      } else {
        return {
          'isLoading': false,
          'errorMessage': '',
          'user': user,
        };
      }
    } catch (e) {
      return {
        'isLoading': false,
        'errorMessage': 'Error: $e',
        'user': null,
      };
    }
  }

  Future<void> saveProfileImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_url', url);
  }

  Future<String?> getProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image_url');
  }
}

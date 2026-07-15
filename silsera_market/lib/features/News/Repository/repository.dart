import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:silesra/core/config/settings.dart';
import '../models/models.dart';

class ApiRepository {
  // Fetch Promotions
  Future<List<Promotion>> fetchPromotions() async {
    final res = await http.get(Uri.parse('$baseUrl/promotions/'));
    if (res.statusCode == 200) {
      final responseData = json.decode(res.body);
      if (responseData['success'] == true) {
        return (responseData['data'] as List)
            .map((e) => Promotion.fromJson(e))
            .toList();
      }
      throw Exception('Failed to load promotions: ${responseData['message']}');
    }
    throw Exception('Failed to load promotions');
  }

  // Fetch News
  Future<List<News>> fetchNews() async {
    final res = await http.get(Uri.parse('$baseUrl/news/'));
    if (res.statusCode == 200) {
      final responseData = json.decode(res.body);
      if (responseData['success'] == true) {
        return (responseData['data'] as List)
            .map((e) => News.fromJson(e))
            .toList();
      }
      throw Exception('Failed to load news: ${responseData['message']}');
    }
    throw Exception('Failed to load news');
  }

  // Fetch Premium Plans
  Future<List<PremiumPlan>> fetchPremiumPlans() async {
    print("%%%%%%%%%% Fetched Premium plans is called ");
    final res = await http.get(Uri.parse('$baseUrl/premiumplans/'));
    if (res.statusCode == 200) {
      final responseData = json.decode(res.body);
      if (responseData['success'] == true) {
        return (responseData['data'] as List)
            .map((e) => PremiumPlan.fromJson(e))
            .toList();
      }
      throw Exception(
          'Failed to load premium plans: ${responseData['message']}');
    }
    throw Exception('Failed to load premium plans');
  }

  // Fetch Premium Requests to display for all
  Future<List<PremiumRequest>> fetchPremiumRequests() async {
    final res = await http.get(Uri.parse('$baseUrl/premiumrequests/'));
    if (res.statusCode == 200) {
      final responseData = json.decode(res.body);
      if (responseData['success'] == true) {
        return (responseData['data'] as List)
            .map((e) => PremiumRequest.fromJson(e))
            .toList();
      }
      throw Exception(
          'Failed to load premium requests: ${responseData['message']}');
    }
    throw Exception('Failed to load premium requests');
  }

  Future<List<PremiumPostLimitStatus>> fetchUserPremiumRequests(
      int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/users/$userId/premium-requests/'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        return (responseData['data'] as List)
            .map((e) => PremiumPostLimitStatus.fromJson(e))
            .toList();
      }
      throw Exception(
          'Failed to load premium requests: ${responseData['message']}');
    } else {
      throw Exception('Failed to load user requests');
    }
  }

  Future<PremiumStatus> fetchPremiumStatus(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/check-post-limit/$userId/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("The response for the user ${userId}  and ===>  ${data['status']}");

      if (data['status'] == 'ok') {
        return PremiumStatus.fromJson(data);
      } else if (data['status'] == 'no_active_plan') {
        // Provide fallback/default values for missing fields
        return PremiumStatus(
          status: 'no_active_plan',
          allowedPosts: 0,
          currentPosts: 0,

          totalAmount: 0.0,
          usedAmount: 0.0,
          remainingBalance: 0.0,
          expire_date: null, // or DateTime.now() if you prefer
          message: 'No active plan. Please subscribe to a plan.',
        );
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to fetch premium status');
    }
  }
}

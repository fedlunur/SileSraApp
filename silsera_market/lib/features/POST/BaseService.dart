import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/core/config/settings.dart';
import 'package:silesra/core/config/user_auth_data.dart';
import 'package:silesra/features/Accessory/data/accessory_model.dart';

import 'package:silesra/features/Auth/models/user_model.dart';
import 'package:silesra/features/Cars/data/models/car_model.dart';
import 'package:silesra/features/Electronics/data/model/electronics_model.dart';
import 'package:silesra/features/Fashion/data/model/fashion_model.dart';
import 'package:silesra/features/FreeStuff/data/model/free_stuff_model.dart';
import 'package:silesra/features/House/data/model/house_model.dart';
import 'package:silesra/features/Job/data/model/job_vacancy.dart';
import 'package:silesra/features/LOF/data/model/lof_model.dart';
import 'package:silesra/features/OtherItems/data/model/otheritem_model.dart';
import 'package:silesra/features/POST/download_image.dart';
import 'package:silesra/features/Posted_Items/posted_itemmodel.dart';
import 'package:silesra/features/Product/data/models/product_model.dart';
import 'package:silesra/features/Service/data/model/service_model.dart';

class BaseService<T> {
  final String endpoint;
  final Dio _dio = Dio();

  BaseService(this.endpoint);
  Future<int?> _getCurrentUserId() async {
    User? user = await SharedPreferenceHelper.getUser();

    final uid = user?.id;

    if (uid == null) {
      throw Exception("User not logged in. Token is missing.");
    }

    return uid; // Replace with your method to get the token
  }

  Future<String?> _getToken() async {
    User? user = await SharedPreferenceHelper.getUser();

    final token = user
        ?.accessToken; // Make sure this is the access token, not refresh token
    print("Retrieved Token: $token"); // Debugging log
    if (token == null) {
      throw Exception("User not logged in. Token is missing.");
    }
    return token;
  }

  Future<Map<String, dynamic>> _getHeaders() async {
    String? token = await _getToken(); // Fetch JWT token
    if (token == null || token.isEmpty) {
      throw Exception("User not logged in. Token is missing.");
    }
    return {
      'Authorization': 'Bearer $token', // Correct JWT format
      'Content-Type': Headers.jsonContentType,
    };
  }

  Future<Map<String, dynamic>> changePassword(
      Map<String, dynamic> data, String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await _dio.post(
        "$baseUrl/$endpoint/",
        data: jsonEncode(data),
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> loginUser(
    Map<String, dynamic> data,
    Function(Map<String, dynamic>) fromJson,
    String endpoint,
  ) async {
    try {
      final response = await _dio.post("$baseUrl/$endpoint/", data: data);

      // Return the API response
      return response.data;
    } catch (e) {
      // Handle Dio errors (e.g., network errors, server errors)
      if (e is DioException) {
        // Extract error message from the response
        final errorResponse = e.response?.data;
        if (errorResponse != null && errorResponse is Map<String, dynamic>) {
          throw errorResponse['message'] ??
              'An error occurred during registration.';
        } else {
          throw 'An error occurred during registration.';
        }
      } else {
        throw 'An unexpected error occurred.';
      }
    }
  }

  Future<Map<String, dynamic>> createUser(
    Map<String, dynamic> data,
    Function(Map<String, dynamic>) fromJson,
    String endpoint,
  ) async {
    print(" %%%%%%   --->  create user is called  ");
    print("$baseUrl/$endpoint/");
    final response = await _dio.post("$baseUrl/$endpoint/", data: data);
    print(" %%%%%%   --->  The response is  $response ");

    // Return the API response
    return response.data;
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data,
      Function(Map<String, dynamic>) fromJson, String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await _dio.post("$baseUrl/$endpoint/",
          data: data, options: Options(headers: headers));

      // Check if response is successful (assuming success = 200 or contains "success" key)
      if (response.statusCode == 200 || response.data["success"] == true) {
        return {"success": true, "data": response.data};
      } else {
        return {
          "success": false,
          "message": response.data["message"] ?? "Failed to create."
        };
      }
    } catch (e) {
      if (e is DioException) {
        print("Error: ${e.response?.data}");
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Something went wrong."
        };
      }
      return {"success": false, "message": "An unexpected error occurred."};
    }
  }

  Future<T> update(String id, Map<String, dynamic> data,
      Function(Map<String, dynamic>) fromJson) async {
    final headers = await _getHeaders();
    try {
      final response = await _dio.put("$baseUrl/$endpoint/$id",
          data: (data), options: Options(headers: headers));

      return fromJson(response.data);
    } catch (e) {
      print("Error in update request: $e");
      rethrow;
    }
  }

  Future<void> delete(String modelname, int id) async {
    final headers = await _getHeaders();
    try {
      print("%%%%%%% Ready to delete: $modelname with ID: $id");

      final response = await _dio.delete(
        '$baseUrl/$modelname/$id/',
        options: Options(headers: headers),
      );

      // Check if the deletion was successful
      if (response.statusCode == 204) {
        print("%%%%%%% Successfully deleted: $modelname with ID: $id");
      } else {
        print("%%%%%%% Deletion failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in delete request: $e");
      rethrow;
    }
  }

  Future<String> uploadImage(Map<String, dynamic> data) async {
    try {
      FormData formData = FormData.fromMap({
        'content_type': data['content_type'], // ContentType ID
        'object_id': data['object_id'], // Object ID
        'image': await MultipartFile.fromFile(
          data['image'].path,
          filename: data['image'].path.split('/').last,
        ),
      });

      final response = await _dio.post(baseUrl, data: formData);
      return response.data[
          'url']; // Assuming the response contains the URL of the uploaded image
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PostedItem>> fetchPostedItems() async {
    final uid = await _getCurrentUserId();
    String urlMaker = "/savedproducts/phone/$uid/";
    String postedUrl = "$baseUrl$urlMaker";
    final headers = await _getHeaders();
    final response =
        await _dio.get(postedUrl, options: Options(headers: headers));

    if (response.statusCode == 200) {
      List<dynamic> itemsJson = response.data['posted_Items'];

      print(" !!!!!!!!!!!!!!!!! The posted Properties are ,$itemsJson");
      List<PostedItem> postedItems =
          itemsJson.map((item) => PostedItem.fromDict(item)).toList();

      return postedItems;
      // Mapping JSON list to a list of PostedItem objects
    } else {
      throw Exception('Failed to load posted items');
    }
  }

  Future<List<WatchlistResponse>> fetcWatchListItems() async {
    final uid = await _getCurrentUserId();
    print("I will search the current UID  for notifications $uid");
    String urlMaker = "/watchlistbyuid/uid/$uid/";
    String postedUrl = "$baseUrl$urlMaker";
    final headers = await _getHeaders();
    final response =
        await _dio.get(postedUrl, options: Options(headers: headers));

    if (response.statusCode == 200) {
      var result = response.data['watchlist_Items'];

      if (result is! List) {
        throw Exception(
            "Unexpected API response: Expected a List but got ${result.runtimeType}");
      }
      List<WatchlistResponse> postedItems =
          result.map((item) => WatchlistResponse.fromDict(item)).toList();

      return postedItems;
    } else {
      throw Exception('Failed to load posted items');
    }
  }

  Future<void> updateSeenTime(String modelName, int id) async {
    String encodedModelName = Uri.encodeComponent(modelName);
    try {
      final headers = await _getHeaders();
      final response = await _dio.post("$baseUrl/$encodedModelName/$id/seen/",
          options: Options(headers: headers));
      print("Seen count updated successfully: ${response.data}");
    } catch (e) {
      rethrow;
    }
  }

  Future<List<NotificationResponse>> fetchNotificationItems() async {
    final uid = await _getCurrentUserId();
    print(
        "%%%%%%%%%%%%%%  --> I will search the current UID  for notifications $uid");
    String urlMaker = "/notificationlistbyid/uid/$uid/";
    final headers = await _getHeaders();
    String postedUrl = "$baseUrl$urlMaker";

    final response =
        await _dio.get(postedUrl, options: Options(headers: headers));

    if (response.statusCode == 200) {
      var result = response.data['notification_items'];

      if (result is! List) {
        throw Exception(
            "Unexpected API response: Expected a List but got ${result.runtimeType}");
      }

      List<NotificationResponse> postedItems =
          result.map((item) => NotificationResponse.fromDict(item)).toList();
      print(
          "%%%%%%%%%%%%%%  I will return -->Resonse insied notification  $postedItems");
      return postedItems;
    } else {
      throw Exception('Failed to load posted items');
    }
  }

  Future<Map<String, dynamic>> getRoomIfExists(
      Map<String, Object> formData) async {
    try {
      // Construct the query parameters based on formData
      String urlMaker =
          "/chatroomlist/exists/?product_id=${formData['product_id']}&seller=${formData['seller']}&buyer=${formData['buyer']}";
      String postedUrl = "$baseUrl$urlMaker";

      // Get headers
      final headers = await _getHeaders();

      // Send GET request
      final response =
          await _dio.get(postedUrl, options: Options(headers: headers));

      // Check for success
      if (response.statusCode == 200) {
        // Assuming the response contains the room_number key
        if (response.data != null && response.data['room_number'] != null) {
          return {
            "success": true,
            "room_number": response.data['room_number'],
          };
        } else {
          return {
            "success": false,
            "message": "Room not found",
          };
        }
      } else {
        return {
          "success": false,
          "message": "Failed to fetch room. Status: ${response.statusCode}",
        };
      }
    } catch (e) {
      print("Error in getRoomIfExists request: $e");
      return {
        "success": false,
        "message": "An error occurred while fetching the room data.",
      };
    }
  }

  Future<List<ChatMessageList>> fetchChatListBYUid() async {
    final uid = await _getCurrentUserId();
    print(
        " %%%%%%%  back I will search the current UID  for chat Mesages  $uid");
    String urlMaker = "/chat/messages/user/$uid/";

    String postedUrl = "$baseUrl$urlMaker";

    final headers = await _getHeaders();
    final response =
        await _dio.get(postedUrl, options: Options(headers: headers));
    print("Got this repsonse I will fetch all chat list by user $response");
    if (response.statusCode == 200) {
      var result = response.data['messages'];

      if (result is! List) {
        throw Exception(
            "Unexpected API response: Expected a List but got ${result.runtimeType}");
      }
      List<ChatMessageList> postedItems =
          result.map((item) => ChatMessageList.fromJson(item)).toList();

      return postedItems;
    } else {
      throw Exception('Failed to load posted items');
    }
  }

  Future<Response> getRequestModelData(String path,
      {int page = 1, int pageSize = 10}) async {
    try {
      final headers = await _getHeaders(); // Get auth headers

      // Construct the URL correctly using Uri
      final Uri uri = Uri.parse('$baseUrl/$path').replace(
        queryParameters: {
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );

      // Make the API request with the correctly constructed URL
      final response = await _dio.get(
        uri.toString(),
        options: Options(headers: headers),
      );

      return response;
    } catch (e) {
      throw Exception("Failed to fetch data from $path");
    }
  }

  Future<BaseListing> getSingleModelData(int id, String modelname) async {
    try {
      final headers = await _getHeaders(); // Get auth headers
      final response = await _dio.get(
        '$baseUrl/$modelname/byid/$id/', // Append endpoint dynamically
        options: Options(headers: headers),
      );

      // Extract the "result" field from the response
      final Map<String, dynamic> responseData = response.data;
      print("%%%%  Response data is $responseData");
      if (responseData['success'] == true) {
        final Map<String, dynamic> resultData = responseData['result'];

        // Map the result data to the appropriate model
        return PropertyBuilder.createProperty(modelname, resultData);
      } else {
        throw Exception("Failed to fetch data: ${responseData['message']}");
      }
    } catch (e) {
      throw Exception("Failed to fetch data from $modelname: $e");
    }
  }
}

class PropertyBuilder {
  static Future<BaseListing> createProperty(
      String selectedCategory, Map<String, dynamic> productData) async {
    final String category = selectedCategory.toLowerCase();

    switch (category) {
      case "car":
        final data = CarModel.from_dict(productData); // Parse single car
        final datas = [data]; // Wrap in a list
        await updateImages(category, datas); // Use category directly
        return data;

      case "house":
        final data = HouseModel.fromJson(productData); // Parse single house
        final datas = [data]; // Wrap in a list
        await updateImages(category, datas); // Use category directly
        return data;

      case "electronics":
        final electronics = ElectronicsModel.from_dict(
            productData); // Parse single electronics item
        final electronicsList = [electronics]; // Wrap in a list
        await updateImages(category, electronicsList); // Use category directly
        return electronics;

      case "fashion":
        final fashion =
            FashionModel.from_dict(productData); // Parse single fashion item
        final fashionList = [fashion]; // Wrap in a list
        await updateImages(category, fashionList); // Use category directly
        return fashion;

      case "lostorfound":
        final lostOrFound = LostOrFound.from_dict(
            productData); // Parse single lost or found item
        final lostOrFoundList = [lostOrFound]; // Wrap in a list
        await updateImages(category, lostOrFoundList); // Use category directly
        return lostOrFound;

      case "accessory":
        final accessory =
            AccessoryModel.fromJson(productData); // Parse single accessory
        final accessoryList = [accessory]; // Wrap in a list
        await updateImages(category, accessoryList); // Use category directly
        return accessory;

      case "service":
        final service = ServiceOrBusinessType.from_dict(
            productData); // Parse single service
        final serviceList = [service]; // Wrap in a list
        await updateImages(category, serviceList); // Use category directly
        return service;

      case "freestafforitem":
        final freeStaffOrItem = FreeStaffOrItem.from_dict(
            productData); // Parse single free staff or item
        final freeStaffOrItemList = [freeStaffOrItem]; // Wrap in a list
        await updateImages(
            category, freeStaffOrItemList); // Use category directly
        return freeStaffOrItem;

      case "jobvacancy":
        final jobVacancy =
            JobVacancyModel.fromJson(productData); // Parse single job vacancy
        final jobVacancyList = [jobVacancy]; // Wrap in a list
        await updateImages(category, jobVacancyList); // Use category directly
        return jobVacancy;

      case "otheritem":
        final otherItem =
            OtherItem.from_dict(productData); // Parse single other item
        final otherItemList = [otherItem]; // Wrap in a list
        await updateImages(category, otherItemList); // Use category directly
        return otherItem;

      default:
        throw Exception("Invalid category: $category");
    }
  }
}

class NotificationService {
  Future<String?> _getToken() async {
    User? user = await SharedPreferenceHelper.getUser();

    final token = user?.accessToken;

    if (token == null) {
      throw Exception("User not logged in. Token is missing.");
    }

    return token; // Replace with your method to get the token
  }

  Future<Map<String, dynamic>> _getHeaders() async {
    String? token = await _getToken();
    return {
      'Authorization': token != null ? 'Bearer $token' : '',
      'Content-Type': Headers.jsonContentType,
    };
  }

  Future<List<NotificationResponse>> fetchNotificationItems(int uid) async {
    String urlMaker = "/notificationlistbyid/uid/$uid/";
    final headers = await _getHeaders();
    String postedUrl = "$baseUrl$urlMaker";
    final Dio dio = Dio();
    final response =
        await dio.get(postedUrl, options: Options(headers: headers));

    if (response.statusCode == 200) {
      var result = response.data['notification_items'];

      if (result is! List) {
        throw Exception(
            "Unexpected API response: Expected a List but got ${result.runtimeType}");
      }

      List<NotificationResponse> postedItems =
          result.map((item) => NotificationResponse.fromDict(item)).toList();

      return postedItems;
    } else {
      throw Exception('Failed to load posted items');
    }
  }
}

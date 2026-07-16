import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/core/config/ui_data_mapping.dart';

import 'package:silesra/core/config/user_auth_data.dart';
import 'package:silesra/features/Auth/models/user_model.dart';

// const String baseUrl = "http://188.245.105.29:8888/api";
// const String chatip = "188.245.105.29:8888";
// this is for Emulator
// const String chatip = "10.0.2.2:8888";
// const String baseUrl = "http://10.0.2.2:8888/api";
// const String chatip = "localhost:8888";
// const String baseUrl = "http://localhost:8888/api";
// //phone immulator   change the IP after check ipconf of your computer
const String chatip = "192.168.16.86:8888";
const String baseUrl = "http://192.168.16.86:8888/api";

final List<String> serviceTypes = [
  //
  'Catering',
  'Dish Installation',
  'Car Services',
  'Carpet Washing',
  'Aluminium and Glass Work',
  'DJ Services',
  'Cement Providing Services',
  'Delivery',
  'Weyba Tis'
];

final List<String> banks = [
  'Commercial Bank of Ethiopia',
  'Dashen Bank',
  'Awash Bank',
  'Enat Bank',
  'Wegagen Bank',
  'Abay Bank',
  'Amhara Bank',
  'Abyssinia Bank',
  'Birhan Bank',
  'Cooperative Bank of Ormoia',
  'Addis International Bank',
  'Gedaa Bank',
  'Siinqee Bank',
  'Nib Bank',
  'Ahadu Bank',
  'Bunna Bank',
  'Hibret Bank',
  'Lion Bank',
  'Global Bank Ethiopia',
  'Zemen Bank',
  'Hijra Bnak',
  'Zamzam Bank',
  'Tsedey Bank',
  'Tsehay Bank',
];

final List<String> cities = [
  'Addis Ababa',
  'Diredawa',
  'Sheger',
  'Amhara Region',
  'Tigray Region',
  'Oromia Region',
  'Southern Ethiopia',
  'Afar Region',
  'Somali Region',
  'Gurage',
  'Silte Zone'
];

final List<String> fashionTypes = [
  "Clothing",
  "Footwear",
  "Bags",
  "Jewelry",
  "Watches",
  "Hats & Caps",
  "Eyewear",
  "Other"
];
final List<String> accessoryTypes = [
  "Watch",
  "Jewelry",
  "Bag",
  "Belt",
  "Sunglasses",
  "Wallet",
  "Other",
];

final List<String> jobTypes = [
  "Full-time",
  "Part-time",
  "Contract",
  "Temporary",
  "Internship",
  "Remote",
];
final List<String> transmissiontypes = ["Automatic", "Manual"];
// Gender Options
final List<String> genderOptions = ["Male", "Female", "Unisex"];

// Sizes
final List<String> sizes = ["S", "M", "L", "XL", "XXL"];

// Materials
final List<String> materials = [
  "Cotton",
  "Leather",
  "Synthetic",
  "Metal",
  "Wood"
];

// Conditions
final List<String> conditions = [
  "New",
  "Used - Like New",
  "Used - Good",
  "Used - Fair"
];

// Warranty Options
final List<String> warrantyOptions = ["Yes", "No"];

final List<String> serviceCategories = [
  "Consulting",
  "Event Planning",
  "Health & Wellness",
  "Education & Tutoring",
  "Repair Services",
  "Legal Services",
  "Marketing & Advertising",
  "Freelance Work",
  "Home Cleaning",
  "Pet Services",
  "Other"
];

// Lost or Found Types
final List<String> lostOrFoundTypes = [
  "Help me find something I lost",
  "Find the owner of something I found",
];

// Position Types
final List<String> positionTypes = [
  "Full-Time",
  "Part-Time",
  "Internship",
  "Contract",
  "Temporary",
  "Remote"
];

// Experience Levels
final List<String> experienceLevels = [
  "Entry Level",
  "Mid Level",
  "Senior Level",
  "Executive",
  "No Experience Required"
];

// Other Item Categories

// SilesraBankAccount Model
class SilesraBankAccount {
  final int id;
  final String name;
  final String accountNumber;

  SilesraBankAccount({
    required this.id,
    required this.name,
    required this.accountNumber,
  });

  factory SilesraBankAccount.fromJson(Map<String, dynamic> json) {
    return SilesraBankAccount(
      id: json['id'],
      name: json['name'],
      accountNumber: json['account_number'],
    );
  }
}

// CustomerBank Model
class CustomerBank {
  final int id;
  final String name;

  CustomerBank({
    required this.id,
    required this.name,
  });

  factory CustomerBank.fromJson(Map<String, dynamic> json) {
    return CustomerBank(
      id: json['id'],
      name: json['name'],
    );
  }
}

// GeneralSetting Model
class GeneralSetting {
  final int id;
  final String serviceCallNumber;

  GeneralSetting({
    required this.id,
    required this.serviceCallNumber,
  });

  factory GeneralSetting.fromJson(Map<String, dynamic> json) {
    return GeneralSetting(
      id: json['id'],
      serviceCallNumber: json['service_call_number'],
    );
  }
}

class OtherItemCategory {
  final int id;
  final String name;

  OtherItemCategory({required this.id, required this.name});

  factory OtherItemCategory.fromJson(Map<String, dynamic> json) {
    return OtherItemCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  /// Function to parse a list of `OtherItemCategory` objects from JSON response
  static List<OtherItemCategory> fromJsonList(Map<String, dynamic> jsonData) {
    if (jsonData.containsKey('result') && jsonData['result'] is List) {
      return (jsonData['result'] as List)
          .map((item) => OtherItemCategory.fromJson(item))
          .toList();
    } else {
      throw Exception(
          "Invalid data format: Expected a list in 'result' field.");
    }
  }
}

// Service Fee Bank Model
class ServiceFeeBank {
  final int id;
  final String name;

  ServiceFeeBank({required this.id, required this.name});

  factory ServiceFeeBank.fromJson(Map<String, dynamic> json) {
    return ServiceFeeBank(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// Car Make Model
class CarMake {
  final int id;
  final String name;

  CarMake({required this.id, required this.name});

  factory CarMake.fromJson(Map<String, dynamic> json) {
    return CarMake(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// Car Type Model
class CarType {
  final int id;
  final String name;

  CarType({required this.id, required this.name});

  factory CarType.fromJson(Map<String, dynamic> json) {
    return CarType(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class CarSubType {
  final int id;
  final String name;

  CarSubType({required this.id, required this.name});

  factory CarSubType.fromJson(Map<String, dynamic> json) {
    return CarSubType(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class ApiService {
  static Future<String?> getToken() async {
    var result = await SharedPreferenceHelper.fetchUserData();
    User user = result['user'];
    final token = user.accessToken;
    return token;
  } // Make sure you save the token when logging in

  static Future<List<CarType>> fetchCarTypes() async {
    String? token = await getToken(); // Fetch token from SharedPreferences
    print(" !!!!!!!!  The token fetced is $token");
    final response = await http.get(
      Uri.parse('$baseUrl/cartype/'),
      headers: {
        'Authorization': 'Bearer $token', // Add token here
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('success') &&
          responseData['success'] == true) {
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> data = responseData['data'];
          return data.map((item) => CarType.fromJson(item)).toList();
        } else {
          throw Exception(
              'API response missing "data" key or it is not a list');
        }
      } else {
        throw Exception('API returned success: false or unexpected format');
      }
    } else {
      throw Exception(
          'Failed to load car subtypes. Status code: ${response.statusCode}');
    }
  }

  static Future<List<CarSubType>> fetchCarSubTypes() async {
    String? token = await getToken();
    print(" !!!!!!!! The token fetched is $token");

    final response = await http.get(
      Uri.parse('$baseUrl/carsubtype/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('success') &&
          responseData['success'] == true) {
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> data = responseData['data'];
          return data.map((item) => CarSubType.fromJson(item)).toList();
        } else {
          throw Exception(
              'API response missing "data" key or it is not a list');
        }
      } else {
        throw Exception('API returned success: false or unexpected format');
      }
    } else {
      throw Exception(
          'Failed to load car subtypes. Status code: ${response.statusCode}');
    }
  }

  // Base URL for the API

  // Fetch SilesraBankAccount data
  static Future<List<SilesraBankAccount>> fetchSilesraBankAccounts() async {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/silesrabankaccount/'),
      headers: {
        'Authorization': 'Bearer $token', // Add token here
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => SilesraBankAccount.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load SilesraBankAccounts');
    }
  }

  // Fetch CustomerBank data
  static Future<List<CustomerBank>> fetchCustomerBanks() async {
    final response = await http.get(Uri.parse('$baseUrl/customerbank/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => CustomerBank.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load CustomerBanks');
    }
  }

  // Fetch GeneralSetting data
  static Future<List<GeneralSetting>> fetchGeneralSettings() async {
    final response = await http.get(Uri.parse('$baseUrl/generalsetting/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => GeneralSetting.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load GeneralSettings');
    }
  }

  // Fetch Category data
  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category/'));
    print("Category Response is ${response}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Extract the list of categories from "data"
      final List<dynamic> data = responseData["data"];

      // Convert JSON to Category objects and sort by priority (ascending order)
      List<Category> categories = data
          .map((item) => Category.fromJson(item))
          .toList()
        ..sort((a, b) => a.priority.compareTo(b.priority)); // Sort by priority

      return categories;
    } else {
      throw Exception('Failed to load Categories');
    }
  }

  // Fetch CarMake data
  static Future<List<CarMake>> fetchCarMakes() async {
    final response = await http.get(Uri.parse('$baseUrl/carmake/'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      final List<dynamic> data = responseData["data"];

      return data.map((item) => CarMake.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load CarMakes');
    }
  }

  // Fetch CarType data

  // Fetch OtherItemCategory data
  static Future<List<OtherItemCategory>> fetchOtherItemCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/otheritemcatagory/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Extract the list of categories from "result"
      final List<dynamic> data = responseData["result"];
      return data.map((item) => OtherItemCategory.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load OtherItemCategories');
    }
  }
}

final List<String> carTypes = [
  "Abay",
  "Audi",
  "BMW",
  "Cadillac",
  "Chevrolet",
  "Daewoo",
  "Daihatsu",
  "Ford",
  "FIAT",
  "Hummer",
  "Hyundai",
  "Honda",
  "Isuzu",
  "Iveco",
  "Jeep",
  "Kia",
  "Lada",
  "Land Rover",
  "Lexus",
  "Lifan",
  "Mercedes",
  "Mazda",
  "Mitsubishi",
  "Nissan",
  "Peugeot",
  "Scania",
  "Suzuki",
  "Toyota",
  "VW",
  "Volvo",
  "Other",
];

final List<String> carSubTypes = [
  'Bajaj',
  'Sedan',
  'SUV',
  'Truck',
  'Mini Van - Mini Bus',
  'Pickup',
  'Bus',
];

final List<String> carFuelTypes = [
  'Benzin',
  'Diesel',
  'Electric - Hybrid',
];

final List<String> electronicsTypes = [
  "Mobile Phones",
  "Laptops",
  "Tablets",
  "Cameras",
  "Headphones",
  "Speakers",
  "Smartwatches",
  "Other"
];

final List<String> genders = [
  "Male",
  "Female",
];

final List<String> houseTypes = [
  "Apartment",
  "Condominium",
  "House (Ground)",
  "House (G+)",
  "Office Shop",
  "Building",
  "GuestHouse",
  "WareHouse",
  "Land"
];
IconData getCategoryIcon(String iconName) {
  switch (iconName) {
    case 'directions_car':
      return Icons.directions_car;
    case 'house':
      return Icons.house;
    case 'devices':
      return Icons.devices;
    case 'checkroom':
      return Icons.checkroom;
    case 'search':
      return Icons.search;
    case 'watch':
      return Icons.watch;
    case 'help_outline':
      return Icons.help_outline;
    case 'handyman':
      return Icons.handyman;
    case 'card_giftcard':
      return Icons.card_giftcard;
    case 'work':
      return Icons.work;
    case 'more_horiz':
      return Icons.more_horiz;
    default:
      return Icons.help_outline; // Default icon
  }
}

Color parseColor(String rgba) {
  final RegExp regex = RegExp(r'rgba?\((\d+),\s*(\d+),\s*(\d+),\s*([\d\.]+)\)');
  final match = regex.firstMatch(rgba);

  if (match != null) {
    int r = int.parse(match.group(1)!);
    int g = int.parse(match.group(2)!);
    int b = int.parse(match.group(3)!);
    double a = double.parse(match.group(4)!);

    return Color.fromRGBO(r, g, b, a);
  }

  // Default color if parsing fails
  return Colors.grey;
}

String getProductTitle(dynamic product) {
  try {
    String category = product.category?["name"] ?? "Unknown Category";

    String? field = categoryTitleMapping[category];

    switch (field) {
      case "name":
        return product.name ?? "New Product";
      case "title":
        return product.title ?? "New Product";
      case "positionTitle":
        return product.positionTitle ?? "New Job";

      case "busienssOrServiceType":
        return product.busienssOrServiceType ?? "";
      default:
        return "New Product";
    }
  } catch (e) {
    print("❌ Error accessing field in ${product.runtimeType}: $e");
  }
  return "Unknown";
}

String getProductPrice(dynamic product) {
  try {
    print("%%%% Some thing called  $product");
    String category = product.category?["name"] ?? "Unknown Category";
    print("%%%% getProductPrice Catagory $category");
    String? field = categoryPriceMapping[category];
    print("%%%% Filed is  $field");
    switch (field) {
      case "price":
        return product?.price != null ? '${product!.price!.toInt()} ብር' : '0';
      case "payment":
        return product?.payment != null
            ? '${product!.payment!.toInt()} ብር'
            : '0';
      case "salary":
        return product?.salary != null ? '${product!.salary!.toInt()} ብር' : '0';

      case "typeofadd":
        return product.typeofadd ?? "";
      case "positionType":
        return product.positionType ?? "";

      case "busienssOrServiceType":
        return product.busienssOrServiceType ?? "";
      case "none":
        return "";
      default:
        return "Negotable";
    }
  } catch (e) {
    print("❌ Error accessing field in ${product.runtimeType}: $e");
  }
  return "Unknown";
}

String getSaleOrRent(dynamic product) {
  try {
    String category = product.category?["name"] ?? "Unknown Category";

    String? field = categorySaleRentMapping[category];
    print(" %%%%%   Sale or rent filed $field");
    switch (field) {
      case "sell_or_rent":
        return product.sellOrRent ?? "sale";
      case "busienssOrServiceType":
        return product.busienssOrServiceType ?? "";
      case "experianceLevel":
        return product.experianceLevel ?? "Experiance not given";
      case "positionType":
        return product.positionType ?? "New Job";

      case "none":
        return "";

      default:
        return "unknown";
    }
  } catch (e) {
    print("❌ Error accessing field in ${product.runtimeType}: $e");
  }
  return "Unknown";
}

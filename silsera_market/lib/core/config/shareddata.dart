import 'package:silesra/core/config/user_auth_data.dart';
import 'package:silesra/features/Auth/models/user_model.dart';

class SharedData {
  // Private constructor
  SharedData._privateConstructor();

  // Static instance of the class
  static final SharedData _instance = SharedData._privateConstructor();

  // Factory constructor to return the same instance
  factory SharedData() {
    return _instance;
  }

  double latitude = 45.877000;
  double longitude = 98.560000;
  int? postedBy = 0; // Default value until loaded
  String city = '';
  String? phonenumber;
  String? category;

  void setCategory(int cat, String cit, int? posted, String phone) {
    category = cat.toString();
    city = cit;
    postedBy = posted;
    phonenumber = phone;
  }

  Future<String?> getPhone() async {
    User? user = await SharedPreferenceHelper.getUser();
    phonenumber = user?.phone;
    return phonenumber;
  }

  Map<String, dynamic> getCommonData() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "postedby": postedBy,
      "phonenumber": phonenumber,
      "city": city,
      'category': int.parse(category!),
    };
  }
}

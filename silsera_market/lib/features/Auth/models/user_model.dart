class User {
  int? id;
  String firstName; // Camel case (used internally in Flutter)
  String? middleName; // Camel case (used internally in Flutter)
  String? phone;
  String accessToken;
  String refreshToken;
  String? profileImage;
  int? isLoggedIn; // Camel case (used internally in Flutter)
  String? password;

  User({
    this.id,
    required this.firstName,
    this.middleName,
    required this.phone,
    required this.accessToken,
    required this.refreshToken,
    this.profileImage,
    this.isLoggedIn,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'phone': phone,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'profileImage': profileImage,
      'isLoggedIn': isLoggedIn,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        firstName: map['firstName'] ?? '', // Handle snake_case
        middleName: map['middleName'], // Handle snake_case
        phone: map['phone'],
        accessToken: map['accessToken'] ?? '',
        refreshToken: map['refreshToken'] ?? '',
        isLoggedIn: map['isLoggedIn'] ?? 0, // Default to 0 if null
        password: map['password']);
  }
}

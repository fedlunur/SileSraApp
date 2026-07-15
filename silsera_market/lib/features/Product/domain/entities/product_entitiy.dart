class Product {
  final String? id; // Unique identifier for the product
  final String? city; // City where the product is located
  final String? category; // Category of the product
  final String approvalStatus; // Approval status of the product
  final String paymentStatus; // Payment status of the product
  final String? servicefeeBank; // Bank associated with the service fee
  final String? feeReciptImage; // Image of the fee receipt
  final String? feeReciptRefnumber; // Reference number of the fee receipt
  final double? latitude; // Latitude of the product's location
  final double? longitude; // Longitude of the product's location
  final String? phonenumber; // Contact phone number
  final bool removed; // Whether the product is removed
  final DateTime created; // Creation timestamp
  final DateTime updated; // Last update timestamp
  final int? contentType;
  final int? seen;
  Product({
    this.id,
    this.city,
    this.category,
    this.approvalStatus = 'Pending',
    this.paymentStatus = 'Pending',
    this.servicefeeBank,
    this.contentType,
    this.feeReciptImage = "payment.jpg",
    this.feeReciptRefnumber,
    this.latitude,
    this.longitude,
    this.seen,
    this.phonenumber,
    this.removed = false,
    required this.created,
    required this.updated,
  });

  // Convert a Product object into a Map object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'category': category,
      'approvalStatus': approvalStatus,
      'paymentStatus': paymentStatus,
      'servicefeeBank': servicefeeBank,
      'feeReciptImage': feeReciptImage,
      'feeReciptRefnumber': feeReciptRefnumber,
      'latitude': latitude,
      'longitude': longitude,
      'phonenumber': phonenumber,
      'contentType': contentType,
      'seen': seen,
      'removed': removed,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  // Create a Product object from a Map object
  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      city: map['city'],
      category: map['category'],
      approvalStatus: map['approvalStatus'],
      paymentStatus: map['paymentStatus'],
      servicefeeBank: map['servicefeeBank'],
      feeReciptImage: map['feeReciptImage'],
      feeReciptRefnumber: map['feeReciptRefnumber'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      phonenumber: map['phonenumber'],
      seen: map['seen'],
      removed: map['removed'],
      contentType: map['contentType'],
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
    );
  }
}

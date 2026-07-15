import 'dart:convert';


class BaseListing {
  int? id;
  String? name;
  String? city;
  Map<String, dynamic>? category;
  String? approvalStatus;
  String? paymentStatus;
  Map<String, dynamic>? servicefeeBank;
  String? feeReciptImage;
  String? feeReciptRefnumber;
  double? latitude;
  double? longitude;
  String? phonenumber;
  bool removed;
  DateTime created;
  DateTime updated;
  int? contentType;
  final Map<String, dynamic>? postedby;
  int? seen;
  double? price;
  List<dynamic>? images;
  List<dynamic>? reciptimages;
  String? description;
  bool isFavourite;

  BaseListing({
    this.id,
    this.name,
    this.city,
    this.category,
    this.approvalStatus,
    this.paymentStatus,
    this.servicefeeBank,
    this.feeReciptImage,
    this.feeReciptRefnumber,
    this.latitude,
    this.longitude,
    this.phonenumber,
    this.removed = false,
    this.contentType,
    this.price,
    required this.created,
    required this.updated,
    this.images,
    this.reciptimages,
    this.seen,
    this.postedby,
    this.description,
    this.isFavourite=false,
  });

  // Convert a BaseListing object into a Map object
  Map<String, dynamic> to_dict() {
    return {
      'id': id,
      'name': name,
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
      'seen': seen,
      'postedby': postedby,
      'contentType': contentType,
      'removed': removed,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'images': images,
      'reciptimages': reciptimages,
      'price': price,
    };
  }

  // Create a BaseListing object from a Map object
  factory BaseListing.from_dict(Map<String, dynamic> map) {
    var imagesList = map['images'] as List?; // Get the images list if exists
    if (map.containsKey('postedby') && map['postedby'] != null) {
      print("✅ The postedby data: ${map['postedby']}");
    } else {
      print("❌ The postedby data is null or missing!");
    }

    List<dynamic> images = imagesList != null
        ? List<dynamic>.from(imagesList) // Convert to List<String> if exists
        : []; // Empty list if images is not present
    var recimagesList =
        map['reciptimages'] as List?; // Get the images list if exists
    List<dynamic> recimages = recimagesList != null
        ? List<dynamic>.from(recimagesList) // Convert to List<String> if exists
        : []; // Empty list if images is not present
    return BaseListing(
      id: map['id'],
      city: map['city'] ?? 'None',
      name: map['name'] ?? 'Product',
      category: map['category'] ?? {},
      approvalStatus: map['approvalStatus'] ?? 'None',
      paymentStatus: map['paymentStatus'] ?? 'None',
      servicefeeBank: map['servicefeeBank'] ?? {},
      feeReciptImage: map['feeReciptImage'] ?? 'None',
      feeReciptRefnumber: map['feeReciptRefnumber'] ?? 'None',
      latitude: map['latitude'] != null ? double.parse(map['latitude']) : 0.0,
      longitude:
          map['longitude'] != null ? double.parse(map['longitude']) : 0.0,
      phonenumber: map['phonenumber'] ?? 'None',
      removed: map['removed'] ?? false,
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
      price: map['price'] != null ? double.parse(map['price']) : 0.0,
      images: images,
      seen: map['seen'],
      contentType: map['contentType'],
      postedby: map['postedby'] != null
          ? Map<String, dynamic>.from(map['postedby'])
          : null,
      reciptimages: recimages,
      description: map['description'],
      isFavourite:map['isFavourite'] ?? false,
    );
  }

  // Convert a BaseListing object into a JSON string
  String toJson() => json.encode(to_dict());

  // Create a BaseListing object from a JSON string
  factory BaseListing.fromJson(String source) =>
      BaseListing.from_dict(json.decode(source));
}

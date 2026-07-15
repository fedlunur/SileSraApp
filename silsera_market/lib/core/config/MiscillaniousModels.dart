class WatchlistResponse {
  int id;
  int user;
  Map<String, dynamic> category; // Store category as a dictionary
  int objectId;
  String? type;
  String? name;
  int? itemId;
  // double? price;
  // String? sellOrRent;
  String? approval_status;
  DateTime created;

  WatchlistResponse({
    required this.id,
    required this.user,
    required this.category, // Keeping full category info
    required this.objectId,
    required this.created,
    this.itemId,
    this.name,
    this.type,
    // this.price,
    this.approval_status,
    // this.sellOrRent,
  });

  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'user': user,
      'category': category, // Keeping category as a dictionary
      'object_id': objectId,
      'item_id': itemId,
      'name': name,
      'type': type,
      'approval_status': approval_status,
      // 'sell_or_rent': sellOrRent,
      'created': created.toIso8601String(),
    };
  }

  factory WatchlistResponse.fromDict(Map<String, dynamic> map) {
    return WatchlistResponse(
      id: map['id'],
      user: map['user'],
      category: map['category'] ?? {}, // Keeping category as a dictionary
      objectId: map['item_id'],
      name: map['name'],
      type: map['type'],
      itemId: map['item_id'],
      approval_status: map['approval_status'],
      created: DateTime.parse(map['created']),
      // price: map['price'] != null ? double.tryParse(map['price'].toString()) ?? 0.0 : 0.0,
      // sellOrRent: map["sell_or_rent"],
    );
  }
}

class NotificationResponse {
  final int? id; // Nullable int
  final int? objectId; // Nullable int
  final String? message; // Nullable String
  final String? approvalStatus; // Nullable String
  final UserDetails? user; // Nullable UserDetails
  final int? contentType; // Nullable int
  final String created; // Nullable String
  final ProductDetails? product; // Nullable ProductDetails

  NotificationResponse({
    this.id,
    this.objectId,
    this.message,
    this.approvalStatus,
    this.user,
    this.contentType,
    required this.created,
    this.product,
  });

  factory NotificationResponse.fromDict(Map<String, dynamic> map) {
    return NotificationResponse(
      id: map['id'] as int?, // Handle null
      objectId: map['objectId'] as int?, // Handle null
      message: map['message'] as String?, // Handle null
      approvalStatus: map['approvalStatus'] as String?, // Handle null
      user: map['user'] != null
          ? UserDetails.fromDict(map['user'])
          : null, // Handle null
      contentType: map['contentType'] as int?, // Handle null
      created: map['created'] as String, // Handle null
      product: map['product'] != null
          ? ProductDetails.fromDict(map['product'])
          : null, // Handle null
    );
  }
}

class UserDetails {
  int? id;
  String? name; // Nullable field

  UserDetails({
    required this.id,
    this.name,
  });

  // Convert the object to a Map
  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Create an object from a Map
  factory UserDetails.fromDict(Map<String, dynamic> map) {
    return UserDetails(
      id: map['id'] ?? 1,
      name: map['name'],
    );
  }
}

class ProductDetails {
  int? id;
  String? name; // Nullable field
  String? approvalStatus; // Nullable field
  DateTime created;

  ProductDetails({
    required this.id,
    this.name,
    this.approvalStatus,
    required this.created,
  });

  // Convert the object to a Map
  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'name': name,
      'approvalStatus': approvalStatus,
      'created': created.toIso8601String(),
    };
  }

  // Create an object from a Map
  factory ProductDetails.fromDict(Map<String, dynamic> map) {
    return ProductDetails(
      id: map['id'] ?? 1,
      name: map['name'],
      approvalStatus: map['approvalStatus'],
      created: DateTime.parse(map['created']),
    );
  }
}

class ChatRoom {
  final String productId;
  final int seller;
  final int buyer;
  final int contentType;
  final int objectId;

  ChatRoom({
    required this.productId,
    required this.seller,
    required this.buyer,
    required this.contentType,
    required this.objectId,
  });

  // Convert JSON to ChatRoom object
  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      productId: json['product_id'],
      seller: json['seller'],
      buyer: json['buyer'],
      contentType: json['contenttype'],
      objectId: json['objectid'],
    );
  }

  // Convert ChatRoom object to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'seller': seller,
      'buyer': buyer,
      'contenttype': contentType,
      'objectid': objectId,
    };
  }
}

class ChatMessageList {
  final String roomId;
  final int senderId;
  final String senderName;
  final int seller;
  final int buyer;
  final int objectid;
  final String message;
  final String timeAgo;

  ChatMessageList({
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timeAgo,
    required this.seller,
    required this.buyer,
    required this.objectid,
  });

  factory ChatMessageList.fromJson(Map<String, dynamic> json) {
    return ChatMessageList(
      roomId: json['room_id'],
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      message: json['message'],
      timeAgo: json['time_ago'],
      seller: json['seller'],
      buyer: json['buyer'],
      objectid: json['objectid'] ?? 0,
    );
  }
}

class Category {
  final int id;
  final String name;
  final String api;
  final String icon;
  final int priority;
  final String color;
  final String created;
  final List<dynamic> images;
  final int contentType;

  Category({
    required this.id,
    required this.name,
    required this.api,
    required this.icon,
    required this.priority,
    required this.color,
    required this.created,
    required this.images,
    required this.contentType,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      api: json['api'],
      icon: json['icon'],
      priority: json['priority'],
      color: json['color'],
      created: json['created'],
      images: json['images'], // This is a list
      contentType: json['contentType'],
    );
  }
}





class Watchlist {
  int? id;
  Map<String, dynamic> user;
  DateTime? created;
  DateTime? updated;
  String catagory;
  int objectId;
  bool? removed;
  int? contentType;

  Watchlist({
    required this.user,
    required this.catagory,
    required this.objectId,
    this.id,
    this.removed,
    this.contentType,
    this.created,
    this.updated,

  });

  Map<String, dynamic> to_dict() {
    return {
      'user': user,
      'catagory': catagory,
      'object_id': objectId,
      'id': id,
      'catagory': catagory,
    };
  }

  factory Watchlist.from_dict(Map<String, dynamic> map) {
    return Watchlist(
      user: map['user'], // Ensure this is a Map<String, dynamic>
      catagory: map['catagory'] ?? '',
      // Prevent null issues
      objectId: map['objectId'],
      removed: map['removed'],
      contentType: map['content_type'],
      created: map['created'] != null ? DateTime.parse(map['created']) : null,
      updated: map['updated'] != null ? DateTime.parse(map['updated']) : null,
      id: map['id'],
    );
  }
}

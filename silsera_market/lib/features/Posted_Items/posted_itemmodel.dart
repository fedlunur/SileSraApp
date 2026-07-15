
class PostedItem {
  int id;
  String type;
  String? name;
  String approval_status;
  DateTime created;
  Map<String, dynamic> category; // Keeping category as a dictionary

  PostedItem({
    required this.id,
    required this.type,
    required this.approval_status,
    required this.created,
    required this.category,
    this.name,
  });

  factory PostedItem.fromDict(Map<String, dynamic> map) {
    return PostedItem(
      id: map['id'],
      type: map['type'],
      name: map['name'],
      approval_status: map['approval_status'],
      created: DateTime.parse(map['created']),
      category: map['category'] ?? {}, // Keeping category as a dictionary
    );
  }

  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'approval_status': approval_status,
      'created': created.toIso8601String(),
      'category': category, // Keeping category as a dictionary
    };
  }
}

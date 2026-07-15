// models.dart

class Promotion {
  final int id;
  final String description;
  final String shortDescription;
  final double amount;
  final String icon;
  final int user;
  final String createdAt;

  Promotion({
    required this.id,
    required this.description,
    required this.shortDescription,
    required this.amount,
    required this.icon,
    required this.user,
    required this.createdAt,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      description: json['description'],
      shortDescription: json['shortdescription'],
      amount: double.parse(json['amount'].toString()),
      icon: json['icon'],
      user: json['user'],
      createdAt: json['created_at'],
    );
  }
}

class NewsImage {
  final int id;
  final String path;
  final String caption;

  NewsImage({
    required this.id,
    required this.path,
    required this.caption,
  });

  factory NewsImage.fromJson(Map<String, dynamic> json) {
    return NewsImage(
      id: json['id'],
      path: json['path'],
      caption: json['caption'] ?? '',
    );
  }
}

class News {
  final int id;
  final String title;
  final String description;
  final String date;
  final List<NewsImage> images;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.images,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['images'] as List? ?? [];
    List<NewsImage> imagesList =
        imagesJson.map((img) => NewsImage.fromJson(img)).toList();

    return News(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      images: imagesList,
    );
  }
}

class PremiumPlan {
  final int id;
  final String title;
  final String description;
  final double amount;
  final int durationDays;

  PremiumPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.durationDays,
  });

  factory PremiumPlan.fromJson(Map<String, dynamic> json) {
    return PremiumPlan(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      amount: double.parse(json['amount'].toString()),
      durationDays: json['duration_days'],
    );
  }
}

class PremiumRequest {
  final int id;
  Map<String, dynamic> user;
  final Map<String, dynamic> selectedPlan;
  final String requestDate;
  final String? endDate;
  final String? approval_status;

  PremiumRequest(
      {required this.id,
      required this.user,
      required this.selectedPlan,
      required this.requestDate,
      this.endDate,
      this.approval_status});

  factory PremiumRequest.fromJson(Map<String, dynamic> json) {
    return PremiumRequest(
        id: json['id'],
        user: json['user'] ?? {},
        selectedPlan: json['selected_plan'] ?? {},
        requestDate: json['request_date'] ?? '',
        endDate: json['end_date'] ?? '',
        approval_status: json['approval_status'] ?? '');
  }
}

class PremiumPostLimitStatus {
  final String status;
  final int totalAllowedPosts;
  final int currentPosts;
  final int remainingPosts;
  final double totalAmount;
  final double usedAmount;
  final double remainingBalance;
  final String expireDate;
  final String message;

  PremiumPostLimitStatus({
    required this.status,
    required this.totalAllowedPosts,
    required this.currentPosts,
    required this.remainingPosts,
    required this.totalAmount,
    required this.usedAmount,
    required this.remainingBalance,
    required this.expireDate,
    required this.message,
  });

  factory PremiumPostLimitStatus.fromJson(Map<String, dynamic> json) {
    return PremiumPostLimitStatus(
      status: json['status'] ?? 'Status',
      totalAllowedPosts: json['totalallowed_posts'] ?? 0,
      currentPosts: json['current_posts'] ?? 0,
      remainingPosts: json['remaining_posts'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      usedAmount: (json['used_amount'] ?? 0).toDouble(),
      remainingBalance: (json['remaining_balance'] ?? 0).toDouble(),
      expireDate: json['expire_date'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class PremiumStatus {
  final String status;
  final int allowedPosts;
  final int currentPosts;
  final double totalAmount;
  final double usedAmount;
  final double remainingBalance;
  final String message;
  String? expire_date;

  PremiumStatus(
      {required this.status,
      required this.allowedPosts,
      required this.currentPosts,
      required this.totalAmount,
      required this.usedAmount,
      required this.remainingBalance,
      required this.message,
      this.expire_date});

  factory PremiumStatus.fromJson(Map<String, dynamic> json) {
    return PremiumStatus(
        status: json['status'],
        allowedPosts: json['totalallowed_posts'],
        currentPosts: json['current_posts'],
        totalAmount: (json['total_amount'] as num).toDouble(),
        usedAmount: (json['used_amount'] as num).toDouble(),
        remainingBalance: (json['remaining_balance'] as num).toDouble(),
        message: json['message'],
        expire_date: json['expire_date']);
  }
}

// state.dart

import 'package:silesra/features/News/models/models.dart';

abstract class PromotionsPlansNewsState {}

class PromotionsNewsPlansInitial extends PromotionsPlansNewsState {}

class PromotionsNewsPlansLoading extends PromotionsPlansNewsState {}

class PromotionsNewsPlansLoaded extends PromotionsPlansNewsState {
  final List<Promotion> promotions;
  final List<News> newsList;
  final List<PremiumPlan> premiumPlans;
  final List<PremiumPostLimitStatus> userRequests; // ✅ Add this

  PromotionsNewsPlansLoaded({
    required this.promotions,
    required this.newsList,
    required this.premiumPlans,
    required this.userRequests, // ✅ Add this
  });
}

class PromotionsNewsPlansError extends PromotionsPlansNewsState {
  final String message;

  PromotionsNewsPlansError(this.message);
}

class PremiumRequestSuccess extends PromotionsPlansNewsState {
  final String message;

  PremiumRequestSuccess(this.message);
}

class PremiumRequestError extends PromotionsPlansNewsState {
  final String message;

  PremiumRequestError(this.message);
}


// ✅ NEW: Premium Status (individual user plan balance checking)

class PremiumStatusLoading extends PromotionsPlansNewsState {}

class PremiumStatusLoaded extends PromotionsPlansNewsState {
  final PremiumStatus premiumStatus;

  PremiumStatusLoaded(this.premiumStatus);
}

class PremiumStatusError extends PromotionsPlansNewsState {
  final String message;

  PremiumStatusError(this.message);
}
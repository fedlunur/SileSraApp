// event.dart

abstract class PromotionsPlansNewsEvent {}

class FetchPromotionsPlansAndNews extends PromotionsPlansNewsEvent {
  final int userId; // ✅ Add userId here

  FetchPromotionsPlansAndNews({required this.userId});
}

class CreatePremiumRequestEvent extends PromotionsPlansNewsEvent {
  final int userId;
  final int selectedPlanId;
  final List<Map<String, dynamic>> receiptImages;
  CreatePremiumRequestEvent(
      {required this.userId,
      required this.selectedPlanId,
      required this.receiptImages});
}

class CheckPremiumStatusEvent extends PromotionsPlansNewsEvent {
  final int userId;
  CheckPremiumStatusEvent(this.userId);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silesra/features/News/Repository/repository.dart';
import 'package:silesra/features/News/models/models.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'event.dart';
import 'state.dart';

class PromotionsPlansNewsBloc
    extends Bloc<PromotionsPlansNewsEvent, PromotionsPlansNewsState> {
  final ApiRepository repo;

  PromotionsPlansNewsBloc(this.repo) : super(PromotionsNewsPlansInitial()) {
    // ✅ Unified handler for everything
    on<FetchPromotionsPlansAndNews>((event, emit) async {
      emit(PromotionsNewsPlansLoading());
      try {
        print("Loading data for user ID: ${event.userId}");
        final userRequests = await repo.fetchUserPremiumRequests(event.userId);
        final premiumPlans = await repo.fetchPremiumPlans();
        final promotions = await repo.fetchPromotions();
        final newsList = await repo.fetchNews();

        emit(PromotionsNewsPlansLoaded(
          promotions: promotions,
          newsList: newsList,
          premiumPlans: premiumPlans,
          userRequests: userRequests, // ✅ added here
        ));
      } catch (e) {
        emit(PromotionsNewsPlansError(
            'Failed to load promotions, news, plans, or user requests: $e'));
      }
    });

    // ✅ Keep create event separate, since it's a write operation
    on<CreatePremiumRequestEvent>((event, emit) async {
      emit(PromotionsNewsPlansLoading());


      try {
        final userService = ListingProvider().userService;
        final formData = {
          'user': event.userId,
          'selected_plan': event.selectedPlanId,
          'PromotionsPlansNewsEvent':event.receiptImages
        };

        final response = await userService.create(
          formData,
          PremiumRequest.fromJson,
          'premiumrequests',
        );

        if (response['success'] == true) {
          emit(PremiumRequestSuccess("Premium request created successfully!"));
        } else {
          emit(PromotionsNewsPlansError("Failed to create request."));
        }
      } catch (e) {
        emit(PromotionsNewsPlansError("Error creating request: $e"));
      }
    });

    // ✅ NEW: Check Premium Status (user's balance and validity)
    on<CheckPremiumStatusEvent>((event, emit) async {
      emit(PremiumStatusLoading());
      try {
   
        final premiumStatus = await repo.fetchPremiumStatus(event.userId);

        emit(PremiumStatusLoaded(premiumStatus));
      } catch (e) {
        emit(PremiumStatusError('Failed to check premium status: $e'));
      }
    });
  }
}

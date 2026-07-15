import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:silesra/features/Auth/presentation/block/user_bloc.dart';
import 'package:silesra/features/Auth/presentation/block/user_state.dart';
import 'package:silesra/features/News/Block/block.dart';
import 'package:silesra/features/News/Block/event.dart';
import 'package:silesra/features/News/Block/state.dart';
import 'package:silesra/features/News/models/models.dart';
import 'package:silesra/features/Product/presentation/screens/PreiumuPaymentScreen.dart';

class Premiumaccount extends StatefulWidget {
  const Premiumaccount({super.key});

  @override
  State<Premiumaccount> createState() => _PremiumaccountState();
}

class _PremiumaccountState extends State<Premiumaccount> {
  int? _selectedPlanId;
  late PremiumPlan selectedPreiumPlan;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserBloc>().state is UserLoaded
          ? (context.read<UserBloc>().state as UserLoaded).user
          : null;

      if (user != null) {
        context.read<PromotionsPlansNewsBloc>().add(
              FetchPromotionsPlansAndNews(userId: user.id!),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserBloc bloc) =>
        bloc.state is UserLoaded ? (bloc.state as UserLoaded).user : null);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Premium Plans and Packages',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<PromotionsPlansNewsBloc,
                    PromotionsPlansNewsState>(
                  builder: (context, state) {
                    if (state is PromotionsNewsPlansLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PromotionsNewsPlansLoaded) {
                      final premiumPlans = state.premiumPlans;
                      final postLimitStatus = state.userRequests;

                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // === Premium Plans Section ===
                          const Text(
                            "🎯 Available Premium Plans",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: premiumPlans.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final plan = premiumPlans[index];
                              final isSelected = _selectedPlanId == plan.id;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPlanId = plan.id;
                                    selectedPreiumPlan = plan;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFE0F0FF)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF168AE3)
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "🎉 ${plan.title}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(Icons.check_circle,
                                                color: Color(0xFF168AE3)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        plan.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          const Text("Tip:  Select A new plan !"),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _selectedPlanId == null
                                  ? null
                                  : () {
                                      final promotionsBloc = context
                                          .read<PromotionsPlansNewsBloc>();
                                      int userId = user!
                                          .id!; // Replace with actual user ID
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider.value(
                                            value: promotionsBloc,
                                            child: PreimumPaymentScreen(
                                              userId: userId,
                                              selectedPlanId:
                                                  selectedPreiumPlan,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF168AE3),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Create Premium Request",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text("💡 Your Premium Packages with Us!"),
                          const SizedBox(height: 12),

                          // === User Requests Section ===
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (postLimitStatus == null)
                                    const Text("No premium requests yet.")
                                  else ...[
                                    // Display the total values in one card
                                    Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Check if the list is empty or contains data
                                            if (postLimitStatus == null ||
                                                postLimitStatus.isEmpty)
                                              const Text(
                                                  "No premium requests yet.")
                                            else ...[
                                              // Display the total values in one card (for the first item in the list)
                                              Card(
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "🎯 Total Plan Status"),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                            "Total Remaining Posts: ${postLimitStatus[0].remainingPosts}"),
                                                        Text(
                                                            "Total Allowed Posts: ${postLimitStatus[0].totalAllowedPosts}"),
                                                        Text(
                                                            "Total Used Posts: ${postLimitStatus[0].currentPosts}"),
                                                        Text(
                                                            "Total Remaining Balance: \$${postLimitStatus[0].remainingBalance.toStringAsFixed(2)}"),
                                                        Text(
                                                            "Plan Expiry: ${postLimitStatus[0].expireDate}"),
                                                        Text(
                                                            "Message: ${postLimitStatus[0].message}"),
                                                      ],
                                                    ),
                                                    trailing: Icon(
                                                      postLimitStatus[0]
                                                                  .status ==
                                                              'ok'
                                                          ? Icons.check_circle
                                                          : Icons.error,
                                                      color: postLimitStatus[0]
                                                                  .status ==
                                                              'ok'
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    } else if (state is PromotionsNewsPlansError) {
                      return Center(child: Text(state.message));
                    }

                    return const SizedBox.shrink(); // fallback
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

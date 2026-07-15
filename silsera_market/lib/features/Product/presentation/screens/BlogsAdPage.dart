import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:silesra/features/Auth/presentation/block/user_bloc.dart';
import 'package:silesra/features/Auth/presentation/block/user_state.dart';
import 'package:silesra/features/News/Block/block.dart';
import 'package:silesra/features/News/Block/event.dart';
import 'package:silesra/features/News/Block/state.dart';

class BlogAdsPage extends StatefulWidget {
  const BlogAdsPage({super.key});

  @override
  State<BlogAdsPage> createState() => _BlogAdsPageState();
}

class _BlogAdsPageState extends State<BlogAdsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserBloc bloc) =>
        bloc.state is UserLoaded ? (bloc.state as UserLoaded).user : null);
    // Fetching premium plans only
    context
        .read<PromotionsPlansNewsBloc>()
        .add(FetchPromotionsPlansAndNews(userId: user!.id!));
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'News ',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<PromotionsPlansNewsBloc,
                    PromotionsPlansNewsState>(
                  builder: (context, state) {
                    if (state is PromotionsNewsPlansLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PromotionsNewsPlansLoaded) {
                      // Accessing only the premium plans from the loaded state
                      final premiumPlans = state.newsList;

                      return ListView.separated(
                        itemCount: premiumPlans.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final plan = premiumPlans[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "🎉 ${plan.title}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
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
                          );
                        },
                      );
                    } else if (state is PromotionsNewsPlansError) {
                      return Center(child: Text(state.message));
                    }

                    return const SizedBox();
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF168AE3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

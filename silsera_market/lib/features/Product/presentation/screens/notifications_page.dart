import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/features/Auth/models/user_model.dart';
import 'package:silesra/features/Notification/bloc/notification_bloc.dart';
import 'package:silesra/features/POST/ListingProvider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  User? _user;
  final Set<int> _pendingDeletes = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pendingDeletes.isNotEmpty) {
        _deletePendingNotifications();
      }
    });
  }

  String timeAgo(DateTime createdAt) {
    DateTime createdTime = createdAt.toLocal();
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdTime);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inHours < 1) return "${difference.inMinutes} minutes ago";
    if (difference.inDays < 1) return "${difference.inHours} hours ago";
    return DateFormat('MMM d, yyyy').format(createdTime);
  }

  Future<void> _deleteNotification(int notificationId) async {
    context
        .read<NotificationBloc>()
        .add(NotificationDeleteEvent(notificationId));
    
  }

  Future<void> _deletePendingNotifications() async {
    for (var id in _pendingDeletes) {
      await _deleteNotification(id);
    }
    _pendingDeletes.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notification'),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _deletePendingNotifications(); // Ensure pending deletions are processed
              if (mounted) {
                context.go('/home');
              }
            }),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          // Declare the variable here, outside of the if block
          List<NotificationResponse> notifications = [];

          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            notifications = state.notifications; // Now you can assign the value
            if (notifications.isEmpty) {
              return const Center(child: Text("No Notifications available"));
            }
          } else if (state is NotificationError) {
            return Center(child: Text(state.message));
          } else {
            // Handle any other states if needed
            return const Center(child: Text("Unknown state"));
          }
          // Now you can use the 'notifications' variable here, as it is in scope
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: notifications.length, // Use the variable here
            itemBuilder: (context, index) {
              final notification =
                  notifications[index]; // Use the variable here
              return Dismissible(
                key: Key(notification.id.toString()),
                direction: DismissDirection.horizontal,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  setState(() {
                    // Remove the dismissed item from the list
                    notifications.removeAt(index);

                    // Add the ID to pending deletes for background deletion
                    _pendingDeletes.add(notification.id!);
                  });
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromRGBO(248, 252, 255, 1),
                      border: Border.all(
                        color: const Color.fromRGBO(21, 138, 226, 1),
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(799.2),
                            color: const Color.fromRGBO(22, 138, 227, 0.16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.apartment,
                            color: Color.fromRGBO(21, 138, 226, 1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Product: ${"Product"}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notification.message ?? "",
                                style: const TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.75),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "on: ${timeAgo(DateTime.parse(notification.created))}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

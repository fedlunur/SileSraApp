import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/core/config/user_auth_data.dart';
import 'package:silesra/features/Auth/models/user_model.dart';
import 'package:silesra/features/Auth/presentation/block/user_bloc.dart';
import 'package:silesra/features/Auth/presentation/block/user_state.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/Product/presentation/screens/chatScreenFromMessageList.dart';
import 'package:silesra/features/Product/presentation/widgets/custom_bottom_navigation.dart';
import 'package:silesra/features/Product/presentation/widgets/custom_floating_action_button.dart';

import 'package:go_router/go_router.dart';

// Message Page Load first Message
class MessagesWidget extends StatefulWidget {
  const MessagesWidget({super.key});

  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  int _currentIndex = 2; // Assuming the Messages Page index is 2
  final chatroomService = ListingProvider().chatroomService;
  List<ChatMessageList> chatMessageList = [];

  bool isLoading = true; // Initialize to true to show progress indicator

  @override
  void initState() {
    super.initState();
    _fetchChatListings();
  }

  Future<void> _fetchChatListings() async {
    final listingProvider =
        Provider.of<ListingProvider>(context, listen: false);

    try {
      List<ChatMessageList> messages =
          await listingProvider.chatroomService.fetchChatListBYUid();

      setState(() {
        chatMessageList = messages;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching messages: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 252, 255, 1),
      appBar: AppBar(
        title: const Text('Messages'),
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
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : chatMessageList.isEmpty
              ? const Center(child: Text("No messages found"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: chatMessageList.length,
                  itemBuilder: (context, index) {
                    final message = chatMessageList[index];
                    return MessageItem(message: message);
                  },
                ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          context.go('/home');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/wishlist');
              break;
            case 2:
              context.go('/messages');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  final ChatMessageList message;

  const MessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserBloc bloc) =>
        bloc.state is UserLoaded ? (bloc.state as UserLoaded).user : null);

    print("%%%%%%% Accessing the Currenet Logged User from state ");
    return GestureDetector(
      onTap: () {
        // print("Tapped message: ${message.senderName}, "
        //     "%%%%%%%-->  Sender ID: ${message.senderId}, "
        //     "Seller ID: ${message.seller}, "
        //     "Object ID: ${message.objectid}"
        //     "Current Logged User : ${_user!.id!}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreenFromMessage(
              username: message.senderName,
              userId: message.senderId,
              buyerId: message.buyer,
              sellerId: message.seller, // Ensure this is available
              objectid: message.objectid, // Ensure this is available
              currentloggeduser: user!.id!,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            color: const Color.fromRGBO(21, 138, 226, 1),
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromRGBO(21, 138, 226, 1),
              child: Text(
                message.senderName[0], // Use first letter of sender's name
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.senderName, // Show sender's name
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.message, // Show the actual message
                    style: const TextStyle(
                      color: Color.fromRGBO(21, 138, 226, 1),
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.timeAgo, // Show the actual message
                    style: const TextStyle(
                      color: Color.fromRGBO(7, 38, 62, 1),
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

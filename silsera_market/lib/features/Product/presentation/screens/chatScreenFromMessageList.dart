import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';
import 'package:silesra/core/config/settings.dart';

class ChatScreenFromMessage extends StatefulWidget {
  final String username;
  final int userId;
  final int sellerId;
  final int objectid;
  final int buyerId;
  final int currentloggeduser;

  const ChatScreenFromMessage(
      {super.key, required this.username,
      required this.userId,
      required this.sellerId,
      required this.buyerId,
      required this.objectid,
      required this.currentloggeduser});

  @override
  _ChatScreenFromMessageState createState() => _ChatScreenFromMessageState();
}

class _ChatScreenFromMessageState extends State<ChatScreenFromMessage> {
  // Constants for colors and padding
  static const Color myMessageColor = Color(0xFF168AE3);
  static const Color otherMessageColor = Color(0xFFFBFDFF);
  static const Color primaryColor = Colors.blue;
  static const EdgeInsets messagePadding = EdgeInsets.all(12);
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 8);

  // WebSocket channel
  late WebSocketChannel channel;
  final chatroomService = ListingProvider().chatroomService;
  // Messages list
  List<Map<String, dynamic>> messages = [];
  bool isloading = false;
  // Controllers and focus nodes
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false; // Typing indicator

  // Navigation flag
  bool _isNavigating = false;
  Future<String?> getRoomNumber() async {
    try {
      setState(() {
        isloading = true;
      });

      final roomData = await chatroomService.getRoomIfExists({
        'product_id': widget.objectid,
        'seller': widget.sellerId,
        'buyer': widget.buyerId,
      });

      if (roomData['success'] == true &&
          roomData['room_number'] != null) {
        print("Existing room found: ${roomData['room_number']}");
        return roomData['room_number'];
      }

      // Delay showing Snackbar to avoid inherited widget error
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chatting is not possible')),
        );
      });

      return null;
    } catch (error) {
      print("Error: $error");

      // Delay showing Snackbar to avoid inherited widget error
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });

      return null;
    } finally {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  String displayName = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted && messages.isEmpty && isloading) {
      isloading = false; // Prevent multiple SnackBars
      Future.delayed(const Duration(microseconds: 500), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loading chat messages...')),
        );
      });
    }
  }

// When messages are loaded, dismiss the SnackBar
  void onMessagesLoaded() {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch the room number and establish WebSocket connection
    getRoomNumber().then((roomNumber) {
      if (roomNumber!.isNotEmpty) {
        // Room number retrieved successfully, now set up WebSocket connection

        // Establish WebSocket connection using the room number (UUID as string)
        channel = WebSocketChannel.connect(
          Uri.parse(
              "ws://$chatip/ws/chat/$roomNumber/?user_id=${widget.currentloggeduser}"),
        );

        print(
            'WebSocket URL: ws://10.0.2.2:8888/ws/chat/$roomNumber/?user_id=${widget.currentloggeduser}');

        // Listen for incoming WebSocket messages
        channel.stream.listen((message) {
          final data = jsonDecode(message);
          if (data['chat_history'] != null) {
            // Handle initial chat history
            setState(() {
              messages = List<Map<String, dynamic>>.from(data['chat_history']);
            });
            _scrollToBottom();
          } else {
            // Handle new messages
            setState(() {
              messages.add({
                'sender_id': data['sender_id'],
                'message': data['message'],
              });
            });
            _scrollToBottom();
          }
        });
      } else {
        print("Failed to retrieve or create a chat room.");
      }
    });
  }

  // Safe navigation back
  void _navigateBack(BuildContext context) {
    if (_isNavigating) return; // Prevent multiple calls
    _isNavigating = true; // Set the flag to true

    Navigator.maybePop(context).then((_) {
      _isNavigating = false; // Reset the flag after navigation
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        " %%%%% chat message The Seller Id is ${widget.sellerId} and Buyer is logged is ${widget.currentloggeduser}");
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Prevents UI from resizing incorrectly
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _navigateBack(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Text(
                "W",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  "last seen recently",
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Chat messages
            Column(
              children: [
                Expanded(
                  child: Visibility(
                    visible: !isloading, // Show ListView only when not loading
                    replacement: const Center(
                      child:
                          CircularProgressIndicator(), // Show loading indicator
                    ),

                    child: ListView.builder(
                      controller: _scrollController,
                      padding: messagePadding,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        print(" %%%%% The total Message is===>  $message");
                        // Determine if the message is from the current user

                        bool isMe =
                            widget.currentloggeduser == message['sender_id'];
                        print(" %%%%% Is me is ===>  $isMe");
                        return _buildMessageTile(message, isMe);
                      },
                    ),
                  ),
                ),
                // Add a spacer to avoid overlap with the bottom sheet
                const SizedBox(
                    height: 80), // Adjust this height based on your input area
              ],
            ),

            // Typing indicator
            if (isTyping)
              Positioned(
                bottom: 80, // Adjust this position based on your input area
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Wade Warren is typing...",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // Bottom sheet for message input
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildMessageInput(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile(Map<String, dynamic> message, bool isMe) {
    String displayName;
    print(
        "%%%%  IsMe is sent for buid Tile $isMe logged user   ${widget.currentloggeduser} buyer ${message['buyer']} ");
    if (isMe) {
      displayName = 'You'; // For the current logged-in user
    } else {
      if (widget.currentloggeduser == message['buyer']) {
        displayName = "Owner";
      } else {
        displayName = message['sender_name'];
      }
    }
    //if (widget.curresntloggeduser == message['buyer']) {
    //   print(
    //       "%%%%  true {widget.currentloggeduser == message['buyer']}   ${widget.currentloggeduser}");
    //   displayName = message['buyer_name'];
    // } else {
    //   print("else %%%%  true {widget.currentloggeduser ");
    //   //displayName = "buyer"; // Handle null gracefully
    //   displayName = message['buyer_name'];
    // }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: messagePadding,
        decoration: BoxDecoration(
          color: isMe ? myMessageColor : otherMessageColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(15),
          ),
        ),
        constraints: const BoxConstraints(maxWidth: 280),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person,
                    color: Color.fromARGB(255, 91, 166, 242), size: 16),
                const SizedBox(width: 5),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 85, 2, 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              message['message'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: isMe ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message['timestamp']?.toString() ?? '',
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: inputPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 120, // Set a maximum height for the input field
              ),
              child: SingleChildScrollView(
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  maxLines: null, // Allow unlimited lines
                  minLines: 1,
                  style: const TextStyle(
                      color: Colors.black), // Set text color to black
                  decoration: InputDecoration(
                    hintText: "Write your message here",
                    hintStyle: TextStyle(
                        color: Colors
                            .grey.shade500), // Optional: Set hint text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: otherMessageColor,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),
                  onSubmitted: (value) => _sendMessage(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: const CircleAvatar(
              backgroundColor: primaryColor,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      // Send message via WebSocket
      channel.sink.add(jsonEncode({
        'message': _messageController.text,
        'sender_id': widget.currentloggeduser,
      }));

      // Clear the input field
      _messageController.clear();
      _focusNode.unfocus();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    print("%%%%%% Scroll to bottom is called ");
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    _scrollController.dispose();
    super.dispose();
  }
}

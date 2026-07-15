import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:silesra/core/config/settings.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final int userId;
  final int sellerId;
  final dynamic product;
  final int objectid;
  final int contenttypeid;
  final String token;

  const ChatScreen(
      {super.key, required this.username,
      required this.userId,
      required this.sellerId,
      required this.product,
      required this.token,
      required this.contenttypeid,
      required this.objectid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Constants for colors and padding
  static const Color myMessageColor = Color(0xFF168AE3);
  static const Color otherMessageColor = Color(0xFFFBFDFF);
  static const Color primaryColor = Color(0xFF168AE3);
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
  final bool _isNavigating = false;
  Future<String> getRoomNumber() async {
    try {
      setState(() {
        isloading = true;
      });
    
      // Check if a room already exists
      final roomData = await chatroomService.getRoomIfExists({
        'product_id': widget.objectid,
        'seller': widget.sellerId,
        'buyer': widget.userId,
      });

      if (roomData['success'] == true &&
          roomData['room_number'] != null) {
        print("Existing room found: ${roomData['room_number']}");
        return roomData['room_number']; // Return existing room number
      }

      // Room doesn't exist, create a new one
      final formData = {
        "product_id": widget.objectid,
        "seller": widget.sellerId,
        "buyer": widget.userId,
        "contenttype": widget.contenttypeid,
        "objectid": widget.objectid
      };

      print("Creating new room with data: $formData");

      final newRoom =
          await chatroomService.create(formData, ChatRoom.fromJson, 'chatroom');

      print("Response from chatroom creation: $newRoom");

      if (newRoom['success'] == true &&
          newRoom['data'] != null &&
          newRoom['data']['success'] == true &&
          newRoom['data']['result'] != null &&
          newRoom['data']['result']['room_number'] != null) {
        String roomNumber = newRoom['data']['result']['room_number'].toString();
        print("New room created successfully: $roomNumber");
        return roomNumber;
      } else {
        throw Exception("Failed to create a chat room.");
      }
    } catch (error) {
      print("Error: $error");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );

      return ''; // Return an empty string in case of failure
    } finally {
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
      if (roomNumber.isNotEmpty) {
        // Room number retrieved successfully, now set up WebSocket connection
        print('Trying to connect with room number: $roomNumber');
        print('User ID: ${widget.userId}');

        // Establish WebSocket connection using the room number (UUID as string)
        channel = WebSocketChannel.connect(
          Uri.parse(
              "ws://$chatip/ws/chat/$roomNumber/?user_id=${widget.userId}&token=${widget.token}"),
        );

        // Listen for incoming WebSocket messages
        channel.stream.listen((message) {
          final data = jsonDecode(message);
          if (data['chat_history'] != null) {
            // Handle initial chat history
            setState(() {
              messages = List<Map<String, dynamic>>.from(data['chat_history']);
            });
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


  @override
  Widget build(BuildContext context) {
    print('user Name:  ${widget.username}');
    print('user ID:  ${widget.userId}');
    print('Product ID:  ${widget.product}');
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Prevents UI from resizing incorrectly
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            print('back I con with :  ${widget.product}');
            if (widget.product == null) {
              print("Error: Product is null");
              return; // Prevent navigation
            }
            context.go(
              '/home',
            );
            //context.push('/detail', extra: {'product': widget.product});
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
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: messagePadding,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      // Determine if the message is from the current user
                      final isMe = message['sender_id'] == widget.userId;
                      return _buildMessageTile(message, isMe);
                    },
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
            if (!isMe)
              Row(
                children: [
                  const Icon(Icons.person, color: primaryColor, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    (widget.sellerId == message['sender_id'])
                        ? 'Owner'
                        : 'Some body', // Display sender ID
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            const SizedBox(height: 5),
            Text(
              message['message'],
              style: TextStyle(
                fontSize: 14,
                color: isMe
                    ? Colors.white
                    : Colors.black87, // Conditional text color
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message['timestamp'].toString(), // Add a timestamp
              style: TextStyle(
                fontSize: 10,
                color: isMe
                    ? Colors.white
                    : Colors.grey.shade600, // Conditional text color
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
  String trimmedMessage = _messageController.text.trim();

  if (trimmedMessage.isNotEmpty) {
    // Send message via WebSocket
    channel.sink.add(jsonEncode({
      'message': trimmedMessage,
      'sender_id': widget.userId,
    }));

    // Clear the input field and unfocus
    _messageController.clear();
    _focusNode.unfocus();
    _scrollToBottom();
  }
}


  void _scrollToBottom() {
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
    try {
      channel.sink.close();
    } catch (e) {
      print("Error closing WebSocket: $e");
    }
    _scrollController.dispose();
    super.dispose();
  }
}

import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/service/auth/auth_service.dart';
import 'package:chat_app/service/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String reveiverEmail;
  final String reveiverID;

  const ChatPage({super.key, required this.reveiverEmail, required this.reveiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // controller of message
  final TextEditingController messageController = TextEditingController();

  // get reference authservice and chatSErvice
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    myFocusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  // show options
  void showOption(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context) {
      return SafeArea(child: Wrap(
        children: [
          // block user button
          ListTile(
            splashColor: Colors.transparent,
            leading: const Icon(Icons.block),
            title: const Text("Block"),
            onTap: () {
              ChatService().blockUser(widget.reveiverID);
              Navigator.pop(context);
            },
          ),

          // Cancel
          ListTile(
            splashColor: Colors.transparent,
            leading: const Icon(Icons.cancel),
            title: const Text("Cancel"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        title: Text(widget.reveiverEmail),
        actions: [
          IconButton(onPressed: () {showOption(context);}, icon: const Icon(Icons.settings_accessibility_outlined))
        ],
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildUserInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderID, widget.reveiverID),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Center(child: Text("Have Error"));
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // return Text("fdaljda");
        return ListView(
          controller: _scrollController,
          reverse: true,
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            var align = senderID == data['senderID']
                ? Alignment.centerRight
                : Alignment.centerLeft;

            return Align(
              alignment: align,
              child: ChatBubble(
                message: data['message'],
                isCurrentUser: senderID == data['senderID'],
                messageId: doc.id,
                userId: data['senderID'],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: MyTextfield(
            obscureText: false,
            hintText: "Type a message",
            controller: messageController,
            focusNode: FocusNode(),
          )),
          Container(
            margin: const EdgeInsets.only(left: 20),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.amber),
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                if (messageController.text != "") {
                  _chatService.sendMessage(
                      widget.reveiverID, messageController.text);
                  messageController.clear();
                  // scrollDown();
                }
              },
              icon: const Icon(
                Icons.arrow_upward,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

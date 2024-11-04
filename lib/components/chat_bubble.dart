import 'package:chat_app/service/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.messageId,
      required this.userId});

  // show options
  void showOption(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              // block user button
              ListTile(
                splashColor: Colors.transparent,
                leading: const Icon(Icons.report),
                title: const Text("Report"),
                onTap: () {
                  ChatService().reportUser(messageId, userId);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Report successfull"),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ));
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
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          showOption(context, messageId, userId);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.orange[400] : Colors.grey.shade500,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

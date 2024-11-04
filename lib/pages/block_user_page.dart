import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/service/auth/auth_service.dart';
import 'package:chat_app/service/chat/chat_service.dart';
import 'package:flutter/material.dart';

class BlockUserPage extends StatelessWidget {
  BlockUserPage({super.key});

  // GEt reference chat service
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // backgroundColor: Theme.of(context).colorSche me.background,
        title: const Text("BLOCK USER"),
        centerTitle: true,
        foregroundColor: Colors.grey,
      ),
      body: StreamBuilder(
        stream: chatService
            .getBlockedUsersStream(authService.getCurrentUser()!.uid),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!
                .map(
                  (userData) => UserTile(
                    email: userData['email'],
                    onTap: () {
                      showDialog(
                        
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          title: Text("Are you sure unblock user?", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  chatService.unBlockUser(userData['uid']);
                                  Navigator.pop(context);
                                },
                                child: const Text("Yes")),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

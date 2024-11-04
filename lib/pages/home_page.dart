import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/service/auth/auth_service.dart';
import 'package:chat_app/service/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

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
        title: const Text("Home"),
        centerTitle: true,
        foregroundColor: Colors.grey,
      ),
      drawer: const MyDrawer(),
      body: StreamBuilder(
        stream: chatService.getUsersStreamExcludingBlocked(),
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
                .map((userData) => UserTile(
                      email: userData['email'],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              reveiverEmail: userData['email'],
                              reveiverID: userData['uid'],
                            ),
                          ),
                        );
                      },
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

import 'package:chat_app/pages/block_user_page.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Setting"),
        centerTitle: true,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          // Switch mode
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            height: 70,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dark Mode",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Switch(
                      value: context.watch<ThemeProvider>().isDarkMode,
                      onChanged: (_) {
                        context.read<ThemeProvider>().toggleTheme();
                      })
                ]),
          ),

          // Block User Page
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => BlockUserPage())),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: 70,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Block User",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

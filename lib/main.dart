import 'package:chat_app/service/auth/auth_gate.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Hoi lang thong cam
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(sharedPreferences: prefs),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      alignment: Alignment.center,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(shape: BoxShape.rectangle),
        width: 430,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: context.watch<ThemeProvider>().themeData,
          home: const AuthGate(),
        ),
      ),
    );
  }
}

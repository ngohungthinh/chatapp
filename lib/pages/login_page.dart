import 'package:chat_app/service/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final void Function()? switchRegister;
  LoginPage({super.key, required this.switchRegister});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  void login(BuildContext context) async {
    try {
      AuthService authService = AuthService();
      await authService.login(
        _emailController.text,
        _pwController.text,
      );
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(e.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Icon(
                  Icons.chat,
                  color: Theme.of(context).colorScheme.primary,
                  size: 70,
                ),
            
                const SizedBox(
                  height: 60,
                ),
            
                // welcome back message
                Text(
                  "Welcome back you've been messed!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            
                const SizedBox(
                  height: 30,
                ),
            
                // email textfield
                MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController,
                ),
            
                const SizedBox(
                  height: 10,
                ),
            
                // pw textfield
                MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: _pwController,
                ),
            
                // Forgot password
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 30),
                  child: Align(
                    alignment: const Alignment(1, 0),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            
                // login button
                MyButton(
                  text: "Login",
                  onTap: () => login(context),
                ),
            
                const SizedBox(
                  height: 30,
                ),
            
                // register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a nember? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: switchRegister,
                      child: Text(
                        "Register now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:chat_app/service/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? switchLogin;
  RegisterPage({super.key, required this.switchLogin});

  //emial and pw text controllers
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwController = TextEditingController();

  final TextEditingController _comfirmPwController = TextEditingController();

  // register method
  void register(BuildContext context) async {
    AuthService authService = AuthService();
    if (_pwController.text == _comfirmPwController.text) {
      try {
        await authService.createUserWithEmailAndPassword(
            _emailController.text, _pwController.text);
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
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Confirm Password is not match"),
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
                  "Let's create an account for you",
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
            
                const SizedBox(
                  height: 10,
                ),
            
                // pw textfield
                MyTextfield(
                  hintText: "Confirm password",
                  obscureText: true,
                  controller: _comfirmPwController,
                ),
            
                const SizedBox(
                  height: 30,
                ),
            
                // register button
                MyButton(
                  text: "Register",
                  onTap: () => register(context),
                ),
            
                const SizedBox(
                  height: 30,
                ),
            
                // register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: switchLogin,
                      child: Text(
                        "Login now",
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

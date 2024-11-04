import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String email;
  final void Function()? onTap;
  const UserTile({super.key, required this.email, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          // side: BorderSide(
          //     color: Theme.of(context).colorScheme.tertiary, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        enableFeedback: false,
        leading:
            Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
        title: Text(
          email,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        onTap: onTap,
      ),
    );
  }
}

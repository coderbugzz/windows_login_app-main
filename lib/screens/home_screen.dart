import 'package:flutter/material.dart';
import 'package:windows_login_app/main.dart';
import 'package:windows_login_app/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          // logout button
          IconButton(
            onPressed: () {
              //clear the shared preference
              sharedPreferences.clear();
              // go back to login page
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to Flutter!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:windows_login_app/helpers/database_helper.dart';

import 'package:windows_login_app/main.dart';
import 'package:windows_login_app/screens/home_screen.dart';
import 'package:windows_login_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // create controllers for the TextFormField to capture user inputs
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final user = await DatabaseHelper.instance
        .loginUser(username: username, password: password);

    if (!context.mounted) return;

    // provide feedback to the user on whether the query succeeded or failed
    if (user.isNotEmpty) {
      //store login state
      sharedPreferences.setBool('IS_LOGGED_IN', true);

      // User found, login successful
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login successful!'),
        backgroundColor: Colors.green,
      ));

      // This code will replace the current route with the new HomeScreen
      // and remove all routes on top of it from the navigation stack.
      // This will prevent the user from clicking back button
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    } else {
      // User not found or incorrect password
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Incorrect username or password!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    // dispose of the controllers before the widget is disposed
    // to prevent memory leaks
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.deepPurple,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Login to your Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 48,
                ),
                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.alternate_email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.key),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 48,
                ),
                // Login button
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _login,
                    child: const Text('LOGIN'),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: TextButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      //
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                    },
                    child: const Text('Create Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

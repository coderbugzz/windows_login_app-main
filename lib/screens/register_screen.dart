import 'package:flutter/material.dart';
import 'package:windows_login_app/helpers/database_helper.dart';
import 'package:windows_login_app/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    // store the values of controllers into variables for easy reference
    final name = _nameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    // result returns the ID of the latest inserted record
    int result = await DatabaseHelper.instance
        .createUser(name: name, username: username, password: password);

    if (!context.mounted) return;

    if (result > 0) {
      //
      // User found, login successful
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully registered user!'),
        backgroundColor: Colors.green,
      ));

      // Navigate back to login screen so the user can test
      // the new account created
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    } else {
      //
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to register user!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    // ensure that the controllers are disposed off
    // to prevent memory leaks
    _nameController.dispose();
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
                  'Register a New Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 48,
                ),

                // User's name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Your name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
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

                // Register
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _register,
                    child: const Text('REGISTER'),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),

                // Back to login
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
                          builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Back to login'),
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

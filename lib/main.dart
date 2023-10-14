import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windows_login_app/helpers/database_helper.dart';
import 'package:windows_login_app/screens/home_screen.dart';
import 'package:windows_login_app/screens/login_screen.dart';
import 'package:windows_login_app/screens/register_screen.dart';

late SharedPreferences sharedPreferences;
void main() async {
// need to be called when initializing the app asynchronously
  WidgetsFlutterBinding.ensureInitialized();

  //initialize the database
  await DatabaseHelper.instance.database;

//innitialize shared preference
  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool? isLoggedIn = sharedPreferences.getBool('IS_LOGGED_IN');

    // print('isLoggedIn $isLoggedIn');

    return MaterialApp(
      // hidet the debug banner shown at the top right of the screen
      debugShowCheckedModeBanner: false,
      title: 'Windows Login with SQLite DB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // when the application loads, show the login screen if the user is not logged in
      // else show home
      initialRoute: isLoggedIn == true ? '/' : '/login',

      // define the routes for login and home screen
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

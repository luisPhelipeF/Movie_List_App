import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_app/pages/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupGetIt();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 23, 15, 70),
        colorScheme: ColorScheme.dark(
          primary: const Color.fromRGBO(200, 172, 214, 1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        ),
        useMaterial3: true,
      ),
      home: const AuthWrapper(), 
    );
  }
}
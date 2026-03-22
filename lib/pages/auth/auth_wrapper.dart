import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/pages/auth/movie_login_page.dart';
import 'package:movie_app/pages/movie_list/movie_list_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        
        if (snapshot.hasData) {
          return const MovieListPage(title: 'Lista de Filmes');
        }

        
        return const MovieLoginPage();
      },
    );
  }
}
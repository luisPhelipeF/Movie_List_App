import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MovieLoginPage extends StatefulWidget {
  const MovieLoginPage({super.key});

  @override
  State<MovieLoginPage> createState() => _MovieLoginPageState();
}

class _MovieLoginPageState extends State<MovieLoginPage> {
  bool isLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '1023944304750-nm6abv5edpkjes1pch2cirnkhdsbv8pc.apps.googleusercontent.com',
  );

  Future<void> signInWithGoogle() async {
    setState(() => isLoading = true);

    try {
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint("Usuário cancelou login");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;


      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      debugPrint("Usuário logado: ${userCredential.user?.email}");
    } catch (e) {
      debugPrint("ERRO LOGIN: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao fazer login com Google'),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 15, 70, 1),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  Image.asset(
                    'assets/icon/logo_panda_claque.png',
                    width: 120,
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                          const Color.fromRGBO(23, 15, 70, 1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.login),
                        SizedBox(width: 8),
                        Text(
                          "Entrar com Google",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
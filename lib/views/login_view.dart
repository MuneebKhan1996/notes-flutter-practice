import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_notes/constants/routes.dart';
import '../utilities/show_error_dialogue.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  void onPressed() async {
    final email = _email.text;
    final password = _password.text;

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser;
      if(user?.emailVerified ?? false){
        Navigator.of(context)
            .pushNamedAndRemoveUntil(notesRoute, (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await showErrorDialogue(context, 'User Not Found');
      } else if (e.code == 'wrong-password') {
        await showErrorDialogue(context, 'Wrong Password Entered');
      }
      await showErrorDialogue(context, 'Error ${e.code}');
    } catch (e) {
      await showErrorDialogue(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login View'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(onPressed: onPressed, child: const Text('Login')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Sign Up'))
        ],
      ),
    );
  }
}

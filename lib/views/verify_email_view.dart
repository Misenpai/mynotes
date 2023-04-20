import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class VertifyEmailView extends StatefulWidget {
  const VertifyEmailView({super.key});

  @override
  State<VertifyEmailView> createState() => _VertifyEmailViewState();
}

class _VertifyEmailViewState extends State<VertifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(children: [
        const Text(
            "We've send you an email verification. Please open it in order\n"),
        const Text(
            "If you haven't recieved the email verification then click here "),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text("Send Email Verification"),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(registerRoute, (route) => false);
          },
          child: const Text("Restart"),
        )
      ]),
    );
  }
}

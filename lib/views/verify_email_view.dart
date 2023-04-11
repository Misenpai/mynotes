import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        const Text("Please verify your Email address: "),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text("Send Email Verification"),
        )
      ]),
    );
  }
}

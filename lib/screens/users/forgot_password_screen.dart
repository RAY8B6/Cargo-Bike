// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../globals/color.dart' as color;

class ForgotPasswordScreen extends StatelessWidget {
  final supabase = Supabase.instance.client;
  User? user;
  TextEditingController emailController = TextEditingController();

  Future resetPassword({required BuildContext context}) async {
    try {
      await supabase.auth.resetPasswordForEmail(emailController.text);
      Navigator.of(context).pop();
    } on AuthException catch (e) {
      debugPrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, "Ok");
          },
        ),
        title: Text(
          "Reset your password",
        ),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Enter your mail address to reset your password.",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  color: color.appColor(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Email address",
                  prefixIcon: Icon(Icons.email, color: color.appColor()),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  resetPassword(context: context);
                },
                child: const Text(
                  "Send a reset password link",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

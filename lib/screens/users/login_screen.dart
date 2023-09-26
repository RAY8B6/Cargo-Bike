//import 'dart:js_interop';

import 'register_screen.dart';
import '../dashboard_screen.dart';
import 'forgot_password_screen.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../globals/color.dart' as color;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Login function
  Future<bool> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    final supabase = Supabase.instance.client;
    bool login = false;
    try {
      final count = await supabase
          .from("profiles")
          .select('*')
          .eq('email', emailController.text);
      if (count.length < 0) {
        debugPrint("Email not found");
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "This email address has not been found. Please create an account."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, "Ok"),
                  child: const Text("Ok"))
            ],
          ),
        );
      } else
        await supabase.auth
            .signInWithPassword(email: email, password: password);

      login = true;
    } on AuthException catch (e) {
      if (e.message == "Invalid login credentials") {
        final count = await supabase
            .from("profiles")
            .select('*')
            .eq('email', emailController.text);
        if (count.length > 0) {
          debugPrint("Email found");
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Error"),
              content: const Text("Incorrect email or password"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, "Ok"),
                    child: const Text("Ok"))
              ],
            ),
          );
        } else {
          debugPrint("Email not found");
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text("Error"),
                    content: const Text(
                        "This email address has not been found. Please create an account."),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, "Ok"),
                          child: const Text("Ok"))
                    ],
                  ));
        }
        debugPrint(count.toString());
        //if (count > 0) debugPrint(" incorrect password");
      }
      debugPrint(e.message);
    }

    return login;
  }

  bool isVisible = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.secondary,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign In",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    "Fill in the form to sign in.",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: "Email address",
                            prefixIcon:
                                Icon(Icons.email, color: color.appColor()),
                          ),
                        ),
                        const SizedBox(
                          height: 26.0,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: isVisible,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: color.appColor(),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              color: color.appColor(),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                child: Text(
                                  "Forgotten your Password ?",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: color.appColor(),
                                  ),
                                ),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordScreen()))),
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              bool login = await loginUsingEmailPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context);
                              if (login == true) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DashboardScreen()));
                              }
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account yet ? ",
                                style: TextStyle(fontSize: 12.0),
                              ),
                              SizedBox(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                  },
                                  child: const Text(
                                    "Create an account.",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

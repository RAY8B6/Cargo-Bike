// ignore_for_file: avoid_print, must_be_immutable

import 'package:application_cargo/screens/users/login_screen.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:email_validator/email_validator.dart';

import '../../globals/color.dart' as color;

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();

  FancyPasswordController _passwordController = FancyPasswordController();

  TextEditingController confirmPasswordController = TextEditingController();

  String profilePicture = 'https://zupimages.net/up/21/39/j59p.png';

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Dear User'),
          content: Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
            'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Continue'),
            ),
          ],
        ),
      );

  Future register({required BuildContext context}) async {
    final bool isEmailValidated = EmailValidator.validate(emailController.text);

    final supabase = Supabase.instance.client;
    try {
      if (!isEmailValidated) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a valid email address."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, "Ok"),
                  child: Text("Ok"))
            ],
          ),
        );
      } else if (passwordController.text.isEmpty) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a password."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, "Ok"),
                  child: Text("Ok"))
            ],
          ),
        );
      } else if (!_passwordController.areAllRulesValidated) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Error"),
            content: Text(
                "Please respect all the password rules. Must have digit, lowercase letter, uppercase letter, minimum 6 characters length"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, "Ok"),
                  child: Text("Ok"))
            ],
          ),
        );
      } else if (confirmPasswordController.text != passwordController.text) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Passwords don't match."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, "Ok"),
                  child: const Text("Ok"))
            ],
          ),
        );
      } else {
        final authResponse = await supabase.auth.signUp(
            email: emailController.text, password: passwordController.text);
        debugPrint('Test uid ${authResponse.user!.id}');

        await supabase.from('profiles').insert([
          {
            'id': authResponse.user!.id,
            'email': emailController.text,
            'has_permissions': 'TRUE',
            'first_name': firstNameController.text,
            'last_name': lastNameController.text,
            'profile_picture': profilePicture,
          }
        ]);

        print(emailController.text);

        // ignore: use_build_context_synchronously
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Success"),
            content: const Text("Account created !"),
            actions: [
              TextButton(
                  onPressed: () async {
                    await showCustomTrackingDialog(context);

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  },
                  child: const Text("Ok"))
            ],
          ),
        );
      }
    } on AuthException catch (e) {
      if (e.message == "User already registered") {
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
              content: const Text(
                  "User already registered. Please sign in or change your password in the sign-in page."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, "Ok"),
                    child: const Text("Ok"))
              ],
            ),
          );
        }
      }
    }
  }

  bool isVisible = true;

  int getStep(double strength) {
    if (strength == 0) {
      return 0;
    } else if (strength < .1) {
      return 1;
    } else if (strength < .2) {
      return 2;
    } else if (strength < .3) {
      return 3;
    } else if (strength < .4) {
      return 4;
    } else if (strength < .5) {
      return 5;
    } else if (strength < .6) {
      return 6;
    } else if (strength < .7) {
      return 7;
    }
    return 8;
  }

  Color? getColor(double strength) {
    if (strength == 0) {
      return Colors.grey[300];
    } else if (strength < .1) {
      return Colors.red;
    } else if (strength < .2) {
      return Colors.red;
    } else if (strength < .3) {
      return Colors.yellow;
    } else if (strength < .4) {
      return Colors.yellow;
    } else if (strength < .5) {
      return Colors.yellow;
    } else if (strength < .6) {
      return Colors.green;
    } else if (strength < .7) {
      return Colors.green;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.secondary,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  "Sign Up",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  "Create an account and start using the app.",
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
              SizedBox(
                height: 15.0,
              ),
              Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        controller: firstNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: "First name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: color.appColor(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: lastNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: "Last name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: color.appColor(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: "Email address",
                          prefixIcon: Icon(
                            Icons.email,
                            color: color.appColor(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FancyPasswordField(
                        passwordController: _passwordController,
                        controller: passwordController,
                        decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: color.appColor(),
                            )),
                        showPasswordIcon: Icon(
                          Icons.visibility_off,
                          color: color.appColor(),
                        ),
                        hidePasswordIcon: Icon(
                          Icons.visibility,
                          color: color.appColor(),
                        ),
                        validationRules: {
                          DigitValidationRule(),
                          LowercaseValidationRule(),
                          UppercaseValidationRule(),
                          MinCharactersValidationRule(6),
                        },
                        validator: (value) {
                          return _passwordController.areAllRulesValidated
                              ? 'Validated'
                              : 'Not Validated';
                        },
                        strengthIndicatorBuilder: (strength) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: StepProgressIndicator(
                              totalSteps: 8,
                              currentStep: getStep(strength),
                              selectedColor: getColor(strength)!,
                              unselectedColor: Colors.grey[300]!,
                            ),
                          );
                        },
                        validationRuleBuilder: (rules, value) {
                          return SizedBox.shrink();
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: isVisible,
                        decoration: InputDecoration(
                          hintText: "Confirm your password",
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
                      SizedBox(
                        height: 26.0,
                      ),
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            register(context: context);
                          },
                          child: Text(
                            "Sign up",
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account ?",
                              style: TextStyle(fontSize: 12.0),
                            ),
                            SizedBox(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  "Sign in.",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

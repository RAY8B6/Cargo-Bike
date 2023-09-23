//import 'package:application_cargo/main.dart';
import 'package:application_cargo/screens/settings_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../../globals/color.dart' as color;

// ignore: must_be_immutable
class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController OldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future changePwd({required BuildContext context}) async {
    if (confirmPasswordController.text != passwordController.text) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text("Passwords doesn't match"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, "Ok"),
                child: Text("Ok"))
          ],
        ),
      );
    } else {
      final supabase = Supabase.instance.client;
      await supabase.auth.updateUser(
        UserAttributes(
          password: passwordController.text,
        ),
      );
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Succes"),
          content: Text("Password modified !"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage())),
                child: Text("Ok"))
          ],
        ),
      );
    }
  }

  //Future<String?> getOldPassword() async {
  //  final supabase = Supabase.instance.client;
//
  //}

  bool isVisible = false;
  bool isVisibleConfirm = false;
  bool isVisibleOld = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actionsIconTheme: IconThemeData(),
        iconTheme: IconThemeData(),
        title: const Text(
          "Change your password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(
                          "You can define here a new password for your account.",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      //Padding(
                      //  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                      //  child: TextFormField(
                      //    enabled: false,
                      //    controller: OldPasswordController,
                      //    obscureText: isVisibleOld,
                      //    decoration: InputDecoration(
                      //      disabledBorder: OutlineInputBorder(
                      //        borderRadius: BorderRadius.circular(8.0),
                      //        borderSide:
                      //            BorderSide(color: color.appColor(), width: 1),
                      //      ),
                      //      focusedBorder: OutlineInputBorder(
                      //        borderRadius: BorderRadius.circular(8.0),
                      //        borderSide:
                      //            BorderSide(color: color.appColor(), width: 1),
                      //      ),
                      //      enabledBorder: OutlineInputBorder(
                      //        borderRadius: BorderRadius.circular(8.0),
                      //        borderSide:
                      //            BorderSide(color: color.appColor(), width: 1),
                      //      ),
                      //      hintText: "Old password",
                      //      contentPadding: EdgeInsets.symmetric(
                      //          vertical: 8, horizontal: 12),
                      //      prefixIcon:
                      //          Icon(Icons.lock, color: color.appColor()),
                      //      suffixIcon: IconButton(
                      //        onPressed: () {
                      //          setState(() {
                      //            isVisibleOld = !isVisibleOld;
                      //          });
                      //        },
                      //        icon: Icon(isVisibleOld
                      //            ? Icons.visibility
                      //            : Icons.visibility_off),
                      //        color: color.appColor(),
                      //      ),
                      //    ),
                      //  ),
                      //),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: isVisible,
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: color.appColor(), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: color.appColor(), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: color.appColor(), width: 1),
                            ),
                            hintText: "New password",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            prefixIcon:
                                Icon(Icons.lock, color: color.appColor()),
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
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: TextField(
                          controller: confirmPasswordController,
                          obscureText: isVisibleConfirm,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: color.appColor(), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: color.appColor(), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: color.appColor(), width: 1),
                            ),
                            hintText: "Confirm your password",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            prefixIcon:
                                Icon(Icons.lock, color: color.appColor()),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisibleConfirm = !isVisibleConfirm;
                                });
                              },
                              icon: Icon(isVisibleConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              color: color.appColor(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    changePwd(context: context);
                  },
                  child: Text(
                    "Apply change",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

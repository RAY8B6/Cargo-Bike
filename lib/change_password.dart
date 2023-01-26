import 'package:application_cargo/main.dart';
import 'package:application_cargo/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:application_cargo/dashboard.dart';

class ChangePasswordScreen extends StatelessWidget {

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future changePwd({required BuildContext context}) async {
    if(confirmPasswordController.text != passwordController.text){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Passwords doesn't match"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, "Ok"),
                child: const Text("Ok"))
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
          title: const Text("Succes"),
          content: const Text("Password modified !"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SettingsPage())),
                child: const Text("Ok"))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.arrow_back, color: Colors.white,),
          onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SettingsPage()));
          },
        ),
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text("Change password", style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  "You can define here a new password for your account",
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: Color(0xff3a57e8), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: Color(0xff3a57e8), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: Color(0xff3a57e8), width: 1),
                    ),
                    hintText: "Password",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    isDense: false,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    prefixIcon: const Icon(Icons.lock,
                        color: Color(0xff212435), size: 24),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: Color(0xff3a57e8), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: Color(0xff3a57e8), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: Color(0xff3a57e8), width: 1),
                    ),
                    hintText: "Confirm Password",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    isDense: false,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    prefixIcon: const Icon(Icons.lock,
                        color: Color(0xff212435), size: 24),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: MaterialButton(
                  onPressed: () {
                    changePwd(context: context);
                  },
                  color: const Color(0xff3a57e8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xffffffff),
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Apply change",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
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
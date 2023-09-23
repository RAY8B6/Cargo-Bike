// ignore_for_file: unused_import

import 'dart:io';

//import 'package:application_cargo/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'users/change_password_screen.dart';
import 'users/customize_profile_screen.dart';
import 'dashboard_screen.dart';
import 'users/login_screen.dart';

import '../globals/color.dart' as color;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String firstName = '';
String lastName = '';
String emailAddress = '';
String profilePicture = 'https://zupimages.net/up/21/39/j59p.png';

final supabase = Supabase.instance.client;

class SettingsPage extends StatelessWidget {
  Future getUserData({required BuildContext context}) async {
    var userInfos = await supabase
        .from('profiles')
        .select('id, first_name, last_name, profile_picture, email')
        .eq('id', supabase.auth.currentUser?.id.toString());
    emailAddress = userInfos[0]['email'];
    firstName = userInfos[0]['first_name'];
    lastName = userInfos[0]['last_name'];
    profilePicture = userInfos[0]['profile_picture'];
  }

  @override
  Widget build(BuildContext context) {
    getUserData(context: context);

    return Scaffold(
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
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.all(8.0),
              color: color.appColor(),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfilePage()));
                  //open edit profile
                },
                title: Text(
                  (firstName == '')
                      ? emailAddress.toString()
                      : firstName.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(profilePicture),
                ),
                trailing: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.lock_outlined,
                      color: color.appColor(),
                    ),
                    title: Text(
                      "Change your password",
                      style: TextStyle(
                          color: color.appColor(), fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen()));
                      //open change password
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person_remove,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Delete your account",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Delete your account ?"),
                        content: const Text(
                            "Do you really want to delete your account and all your data ?  \n\nIf you select Delete we will delete your account on our server. Your app data will also be deleted and you will not be able to retrieve it. \nSince this is a security-sensitive operation, you eventually are asked to login before your account can be deleted."),
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: [
                          TextButton(
                            onPressed: () {
                              deleteUser();
                              /*
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Dialog(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: <Widget>[
                                                    const Text(
                                                        'Your account and your data have been completely removed.'),
                                                    const SizedBox(
                                                        height: 15),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            LoginScreen()));
                                                      },
                                                      child: const Text('Ok'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));*/
                            },
                            child: const Text(
                              'Delete my account',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: color.appColor(),
                    ),
                    title: Text(
                      "Change Language",
                      style: TextStyle(
                          color: color.appColor(), fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      //open change language
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future deleteUser() async {
    var userId = supabase.auth.currentUser?.id.toString();
    debugPrint("CURRENT USER ID : " + userId.toString());

    try {
      await supabase.from('profiles').delete().eq('id', userId);
      debugPrint("user deleted");
    } on AuthException catch (e) {
      debugPrint(e.message);
    }
  }
}

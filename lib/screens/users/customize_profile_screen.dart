import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

String firstName = '';
String lastName = '';
String profilePicture = 'https://zupimages.net/up/21/39/j59p.png';
String email = '';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Future getUserData({required BuildContext context}) async {
    final supabase = Supabase.instance.client;
    var userInfos = await supabase
        .from('profiles')
        .select()
        .eq('id', supabase.auth.currentUser?.id.toString());
    firstName = userInfos[0]['first_name'];
    lastName = userInfos[0]['last_name'];
    profilePicture = userInfos[0]['profile_picture'];
    email = userInfos[0]['email'];
  }

  bool isUpdated = false;
  Future updateUserData({required BuildContext context}) async {
    getUserData(context: context);
    final supabase = Supabase.instance.client;
    try {
      if (fnameController.text.isEmpty) fnameController.text = firstName;
      if (lnameController.text.isEmpty) lnameController.text = lastName;
      if (emailController.text.isEmpty) emailController.text = email;

      await supabase.auth.updateUser(
        UserAttributes(
          email: emailController.text,
        ),
      );

      await supabase.from('profiles').update({
        'first_name': fnameController.text,
        'last_name': lnameController.text,
        'email': emailController.text
      }).match({'id': supabase.auth.currentUser?.id.toString()});

      isUpdated = true;
    } on AuthException catch (e) {
      if (e.message == "Unable to validate email address: invalid format") {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Enter a valid email address."),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"))
            ],
          ),
        );
      }
      debugPrint(e.message);
    }
  }

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();

  bool showPassword = false;
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
          "Edit your profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  profilePicture,
                                ))),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                TextField(
                  controller: fnameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: 'First name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: firstName,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: lnameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: 'Last name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: lastName,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: email,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (fnameController.text.isEmpty &&
                            lnameController.text.isEmpty &&
                            emailController.text.isEmpty) {
                        } else
                          updateUserData(context: context);

                        if (isUpdated == true) {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Success"),
                              content: const Text("Profile updated !"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Ok"))
                              ],
                            ),
                          );
                        } else
                          null;
                      },
                      child: const Text(
                        "Save",
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:application_cargo/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String firstName = '';
String lastName = '';
String profilePicture = 'https://zupimages.net/up/21/39/j59p.png';
String? email = '';

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {



  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  Future getUserData({required BuildContext context}) async {
    final supabase = Supabase.instance.client;
    var userInfos = await supabase.from('profiles').select('id, first_name, last_name, profile_picture').eq('id', supabase.auth.currentUser?.id.toString());
    firstName = userInfos[0]['first_name'];
    lastName = userInfos[0]['last_name'];
    profilePicture = userInfos[0]['profile_picture'];
    email = supabase.auth.currentUser?.email.toString();
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {

    getUserData(context: context);

    return Scaffold(
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
        title: const Text("Edit your profile", style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
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
                              color: Theme.of(context).scaffoldBackgroundColor),
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
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: 'First name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: firstName,
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: 'Last name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: lastName,
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: email,
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SettingsPage()));
                    },
                    child: const Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
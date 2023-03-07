import 'package:application_cargo/change_password.dart';
import 'package:application_cargo/customize_profile.dart';
import 'package:application_cargo/dashboard.dart';
import 'package:application_cargo/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String firstName = '';
String lastName = '';
String profilePicture = 'https://zupimages.net/up/21/39/j59p.png';

class SettingsPage extends StatelessWidget{

  Future getUserData({required BuildContext context}) async {
    final supabase = Supabase.instance.client;
    var userInfos = await supabase.from('profiles').select('id, first_name, last_name, profile_picture').eq('id', supabase.auth.currentUser?.id.toString());
    firstName = userInfos[0]['first_name'];
    lastName = userInfos[0]['last_name'];
    profilePicture = userInfos[0]['profile_picture'];
  }

  @override
  Widget build(BuildContext context){

    getUserData(context: context);

    return Scaffold(
     backgroundColor: const Color.fromARGB(255, 170, 193, 232),
     appBar: AppBar(
       leading: InkWell(
         child: const Icon(Icons.arrow_back, color: Colors.white,),
         onTap: (){
           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const DashboardScreen()));
         },
       ),
       brightness: Brightness.light,
       iconTheme: const IconThemeData(color: Colors.white),
       backgroundColor: Colors.blue,
       title: const Text("Settings", style: TextStyle(color: Colors.white),),
     ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.all(8.0),
              color: Colors.blue,
              child: ListTile(
                onTap: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> EditProfilePage()));
                  //open edit profile
                },
                title: Text(firstName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(profilePicture),
                ),
                trailing: const Icon(Icons.edit, color: Colors.white,),
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.lock_outlined, color: Colors.blue,),
                    title: const Text("Change Password"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ChangePasswordScreen()));
                      //open change password
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.blue,),
                    title: const Text("Change Language"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: (){
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
}
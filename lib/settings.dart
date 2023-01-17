import 'package:application_cargo/dashboard.dart';
import 'package:application_cargo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
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
     ) ,
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
                  //open edit profile
                },
                title: const Text("Test User", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage("https://zupimages.net/up/21/39/j59p.png"),
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
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.blue,),
                    title: const Text("Change Location"),
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
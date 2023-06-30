import 'package:application_cargo/main.dart';
import 'package:application_cargo/map/home_map.dart';
import 'package:application_cargo/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'startDeliveryScreen.dart';

import 'package:permission_handler/permission_handler.dart';

bool permissions = false;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final supabase = Supabase.instance.client;
  User? user;

  Future getUserData({required BuildContext context}) async {
    final supabase = Supabase.instance.client;
    var userInfos = await supabase
        .from('profiles')
        .select('id, first_name, last_name, profile_picture, has_permissions')
        .eq('id', supabase.auth.currentUser?.id.toString());
    permissions = userInfos[0]['has_permissions'];
  }

  //Dashboard items
  Card makeDashboardItem(String title, String img, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(3.0, -1.0),
            colors: [
              Color(0xFF00488D),
              Color(0xFFFFFFFF),
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 3,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            if (index == 0) {
              await Permission.locationWhenInUse.request();

              if (await Permission.locationWhenInUse.request().isGranted) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Home_Map(
                          title: "Map",
                          points: [],
                          idLiv: 2,
                        )));
              }
            }
            if (index == 1) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DeliveryPage()));
            }
            if (index == 2) {}
            if (index == 3) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            }
            //Logout button
            if (index == 4) {}
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  img,
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getUserData(context: context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onTap: () {
            supabase.auth.signOut();
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Alert"),
                content: const Text("You have successfully logged out"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, "Ok");
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomePage()));
                      },
                      child: const Text("Ok")),
                ],
              ),
            );
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 170, 193, 232),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(2),
              children: [
                //index number 0
                //makeDashboardItem("Map", "assets/map.png", 0),
                makeDashboardItem("Start Delivery", "assets/delivery.png", 1),
                //makeDashboardItem(
                //   "Turn On/Off Motor", "assets/power_button.png", 2),
                makeDashboardItem("Manage Settings", "assets/settings.png", 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:application_cargo/maps/delivery_map.dart';
import 'package:application_cargo/screens/settings_screen.dart';
import 'package:application_cargo/screens/users/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'deliveries/deliveries_screen.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../globals/color.dart' as color;

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
    print(userInfos);
  }

  //Dashboard items
  Card makeDashboardItem(String title, String img, int index) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color.appColor(),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      margin: const EdgeInsets.all(20),
      child: Container(
        child: InkWell(
          onTap: () async {
            if (index == 0) {
              await Permission.locationWhenInUse.request();

              if (await Permission.locationWhenInUse.request().isGranted) {
                // ignore: use_build_context_synchronously
                debugPrint("MAAAAAAAP");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DeliveryMap(
                          title: "Map",
                          points: [],
                          idLiv: 2,
                        )));
              }
              debugPrint("MAAAAAAAP");
              //Navigator.of(context).push(
              //    MaterialPageRoute(builder: (context) => const SearchMap()));
            }
            if (index == 1) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DeliveryPage()));
            }
            if (index == 2) {}
            if (index == 3) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Image.asset(
                  img,
                  height: 40,
                  width: 40,
                ),
              ),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 15,
                      color: color.appColor(),
                      fontWeight: FontWeight.w400),
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
        title: Text(
          "Dashboard",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              supabase.auth.signOut();
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Alert"),
                  content: const Text("You have successfully logged out"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text("Ok")),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(2),
              children: [
                //makeDashboardItem("Map", "assets/map.png", 0),
                makeDashboardItem("Deliveries", "assets/delivery.png", 1),
                //makeDashboardItem(
                //"Turn On/Off Motor", "assets/power_button.png", 2),
                makeDashboardItem("Manage Settings", "assets/settings.png", 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

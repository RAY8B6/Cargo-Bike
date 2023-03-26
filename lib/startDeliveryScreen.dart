import 'package:application_cargo/add_delivery.dart';
import 'package:application_cargo/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_delivery.dart';

import 'map/home_map.dart';

int _selectedIndex = 0;
bool permissions = false;

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {

  List<GeoPoint> points = [];

  final _future = Supabase.instance.client
      .from('deliveries')
      .select<List<Map<String, dynamic>>>();

  final supabase = Supabase.instance.client;
  User? user;

  Future getUserData({required BuildContext context}) async {
    final supabase = Supabase.instance.client;
    var userInfos = await supabase.from('profiles').select('id, first_name, last_name, profile_picture, has_permissions').eq('id', supabase.auth.currentUser?.id.toString());
    permissions = userInfos[0]['has_permissions'];
  }

  @override
  Widget build(BuildContext context) {

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
        title: const Text("Delivery screen", style: TextStyle(color: Colors.white),),
      ),

    body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final deliveries = snapshot.data!;
              return
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20.0),

                        const SizedBox(height: 20.0),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: deliveries.length,
                          itemBuilder: ((context, index) {
                            final delivery = deliveries[index];
                            return Ink(
                              child: ListTile(
                                selected: index == _selectedIndex,
                                title: Text("Delivery number ${delivery['id']}"),
                                subtitle: Text("Customers to deliver : ${delivery['nb_customers']}"
                                    "\nPackages to deliver : ${delivery['nb_packages']}"
                                    "\nStatus : ${delivery['status']}"),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                    points = BuildPoints(delivery["points"]);
                                  });
                                },
                            ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20.0),
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Home_Map(title: "Map", points: points, idLiv: _selectedIndex)));
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
                            "Start Delivery",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        if(permissions == true)
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> EditDeliveryPage(index: _selectedIndex)));
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
                              "Edit selected delivery",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10.0),
                        if(permissions == true)
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AddDeliveryPage()));
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
                              "Add a new delivery",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),

                      ],
                  )
                );
            }
          ),
    );
  }

  getPoint(int index, var points,){
    if(points!=null){
      List <double> listPoints=listStrToListDouble(points.toString());
      return ([listPoints[2*(index-1)],listPoints[2*(index-1)+1]]);
    }
  }

  listStrToListDouble(String str){
    String num="";
    List<double> points=[];

    for (int i =1; i<str.length;i++){
      if (str[i] =="." || testInt(str[i])){
        num+=str[i];
      } else if (num!=""){
        points.add(double.parse(num));
        num="";
      }
    }
    return (points);
  }

  bool testInt(String str){
    try {
      int.parse(str);
    } on FormatException {
      return false;
    }
    return true;
  }


  List <GeoPoint> BuildPoints(List<dynamic> listpoint) {
    List<GeoPoint> geo=[];

    for (int i = 0; i<listpoint.length; i++){
      geo.add(GeoPoint(latitude: listpoint[i][0], longitude: listpoint[i][1]));
    }
    return geo;
  }
}
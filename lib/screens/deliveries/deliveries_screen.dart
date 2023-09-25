import 'add_delivery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_delivery_screen.dart';

import '../../globals/color.dart' as color;

import '../../maps/delivery_map.dart';

int _selectedIndex = 0;
bool permissions = false;

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  List<GeoPoint> points = [];

  //final _future = Supabase.instance.client
  //    .from('deliveries')
  //    .select<List<Map<String, dynamic>>>();
  final supabase = Supabase.instance.client;
  User? user;

  Future<List<Map<String, dynamic>>>? getDeliveries() {
    return Supabase.instance.client.from('deliveries').select<
            List<Map<String, dynamic>>>(
        "id, nb_customers, nb_packages, points, status, packages(id, delivery_address)");
  }

  Future getUserData({required BuildContext context}) async {
    final supabase = Supabase.instance.client;
    var userInfos = await supabase
        .from('profiles')
        .select('id, first_name, last_name, profile_picture, has_permissions')
        .eq('id', supabase.auth.currentUser?.id.toString());
    permissions = userInfos[0]['has_permissions'];
    print(userInfos);
  }

  Future deleteDelivery(
      {required BuildContext context, required int id}) async {
    final supabase = Supabase.instance.client;

    debugPrint("id : " + id.toString());
    try {
      await supabase.from('packages').delete().eq('delivery_id', id.toString());
      debugPrint("package deleted");
      await supabase.from('deliveries').delete().eq('id', id.toString());
      debugPrint("delivery deleted");
    } on AuthException catch (e) {
      debugPrint("deleting delivery error : " + e.message);
    }
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
        iconTheme: IconThemeData(),
        actionsIconTheme: IconThemeData(),
        title: Text(
          "Deliveries",
        ),
        actions: [
          IconButton(
              onPressed: () {
                //getDeliveries();
                setState(() {});
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: getDeliveries(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final deliveries = snapshot.data!;
            deliveries.sort((a, b) => a['id'].compareTo(b['id']));
            return SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Theme.of(context).colorScheme.onSecondary,
                  padding: EdgeInsets.all(15),
                  child: Text(
                      "This is the list of availables deliveries that you can start or modify. In the bottom button, you can add a new package.",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                Container(
                  color: color.appColor(),
                  height: 2,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  margin: EdgeInsets.all(10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: deliveries.length,
                    itemBuilder: ((context, index) {
                      final delivery = deliveries[index];
                      if (delivery['status'].toString().contains("vailable") &&
                          delivery.isNotEmpty) {
                        return Column(
                          children: [
                            const SizedBox(height: 12),
                            Card(
                              margin: EdgeInsets.zero,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: color.appColor(),
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Ink(
                                child: ListTile(
                                  selected: index == _selectedIndex,
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Text(
                                              "${delivery['packages'][0]['delivery_address']}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17)),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            FloatingActionButton(
                                                heroTag: null,
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DeliveryMap(
                                                                  title: "Map",
                                                                  points:
                                                                      points,
                                                                  idLiv: delivery[
                                                                      'id'])));
                                                },
                                                child: Icon(
                                                    Icons.play_arrow_rounded)),
                                            FloatingActionButton(
                                                heroTag: null,
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditDeliveryPage(
                                                                  index: delivery[
                                                                      'id'])));
                                                },
                                                child: Icon(Icons.edit)),
                                            FloatingActionButton(
                                                heroTag: null,
                                                onPressed: () {
                                                  showDialog<String>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Confirmation'),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              Text(
                                                                  'Please confirm the action'),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                'Abort'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: const Text(
                                                                'Delete'),
                                                            onPressed:
                                                                () async {
                                                              await deleteDelivery(
                                                                  context:
                                                                      context,
                                                                  id: delivery[
                                                                      'id']);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(() {});
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Icon(Icons.delete)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      print(delivery);
                                      _selectedIndex = index;
                                      points = BuildPoints(delivery["points"]);

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Delivery information'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text(
                                                      "Delivery address :  ${delivery['packages'][0]['delivery_address']}"
                                                      "\nCustomers to deliver : ${delivery['nb_customers']}"
                                                      "\nPackages to deliver : ${delivery['nb_packages']}",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        Text(
                          'All the deliveries have been completed. Create another to start.',
                          style:
                              TextStyle(color: color.appColor(), fontSize: 50),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ),
                ),
                Container(
                  color: color.appColor(),
                  height: 2,
                ),
                const SizedBox(height: 20.0),
                Container(
                  color: Theme.of(context).colorScheme.onSecondary,
                  child: Column(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DeliveryMap(
                                  title: "Map",
                                  points: points,
                                  idLiv: _selectedIndex)));
                        },
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
                      if (permissions == true)
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddDeliveryPage()));
                          },
                          child: const Text(
                            "Add a new package",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ));
          }),
    );
  }

  getPoint(
    int index,
    var points,
  ) {
    if (points != null) {
      List<double> listPoints = listStrToListDouble(points.toString());
      return ([listPoints[2 * (index - 1)], listPoints[2 * (index - 1) + 1]]);
    }
  }

  listStrToListDouble(String str) {
    String num = "";
    List<double> points = [];

    for (int i = 1; i < str.length; i++) {
      if (str[i] == "." || testInt(str[i])) {
        num += str[i];
      } else if (num != "") {
        points.add(double.parse(num));
        num = "";
      }
    }
    return (points);
  }

  bool testInt(String str) {
    try {
      int.parse(str);
    } on FormatException {
      return false;
    }
    return true;
  }

  List<GeoPoint> BuildPoints(List<dynamic> listpoint) {
    List<GeoPoint> geo = [];

    for (int i = 0; i < listpoint.length; i++) {
      geo.add(GeoPoint(latitude: listpoint[i][0], longitude: listpoint[i][1]));
    }
    return geo;
  }
}

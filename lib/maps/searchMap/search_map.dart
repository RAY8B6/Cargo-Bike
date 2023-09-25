import '../../globals/color.dart' as color;
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'services.dart';

import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class SearchMap extends StatefulWidget {
  const SearchMap({
    super.key,
  });

  @override
  State<SearchMap> createState() => _SearchMap();
}

class _SearchMap extends State<SearchMap> {
  late MapController controller;
  List<StaticPositionGeoPoint> markers = [];

  @override
  void initState() {
    super.initState();

    //placemarkers();
  }

  double distTotal = 0;
  double timeTotal = 0;

  double step = 4000;
  String infosBarre = "Not yet";

  int currentPoint = 1;

  List points = [];

  @override
  Widget build(BuildContext context) {
    final LocationService locationService = LocationService();

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          OpenStreetMapSearchAndPick(
            locationPinIconColor: color.appColor(),
            locationPinText: '',
            hintText: 'Search location, places, ...',
            buttonHeight: 0,
            buttonColor: color.appColor(),
            onPicked: (pickedData) {
              print(pickedData.latLong.latitude);
              print(pickedData.latLong.longitude);
              print(pickedData.address);
            },
            onGetCurrentLocationPressed: locationService.getPosition,
          ),

          //SearchBarWidget()
        ],
      ),
    );
  }

  getLocation() async {
    await controller.currentLocation();
  }

  //drawRoads(List tablGeo) async {
  //  timeTotal = 0;
  //  distTotal = 0;
//
  //  for (int i = 0; i < tablGeo.length; i++) {
  //    if (i == 0) {
  //      GeoPoint geoPoint = await controller.myLocation();
  //      draw(geoPoint, tablGeo[i]);
  //    } else {
  //      draw(tablGeo[i], tablGeo[i - 1]);
  //    }
  //  }
//
  //  await Future.delayed(const Duration(seconds: 1));
  //  snack(infosBarre);
  //}
//
  //Color drawColor(double? distance, double? duree) {
  //  if (distance! / duree! > 0.0035) {
  //    return (Colors.green);
  //  }
  //  if (distance / duree > 0.003) {
  //    return (Colors.orange);
  //  }
  //  return (Colors.red);
  //}
//
  //drawMyRoad(List points) async {
  //  GeoPoint myLocation = await controller.myLocation();
//
  //  RoadInfo rInf = await controller.drawRoad(
  //    myLocation,
  //    points[currentPoint - 1],
  //    roadType: RoadType.bike,
  //    roadOption: const RoadOption(
  //      roadColor: Colors.red,
  //      roadWidth: 0,
  //    ),
  //  );
  //  RoadInfo roadInfo = await controller.drawRoad(
  //    myLocation,
  //    points[currentPoint - 1],
  //    roadType: RoadType.bike,
  //    roadOption: RoadOption(
  //      roadColor: drawColor(rInf.distance, rInf.duration),
  //      roadWidth: 20,
  //    ),
  //  );
//
  //  setState(() {
  //    infosBarre =
  //        "Il reste: ${roadInfo.distance.toString()}km in ${((roadInfo.duration)! / 60).floor()}min";
  //  });
  //}
//
  //draw(GeoPoint start, GeoPoint end) async {
  //  RoadInfo rInf = await controller.drawRoad(
  //    start,
  //    end,
  //    roadType: RoadType.bike,
  //    roadOption: const RoadOption(
  //      roadColor: Colors.red,
  //      roadWidth: 0,
  //    ),
  //  );
  //  RoadInfo roadInfo = await controller.drawRoad(
  //    start,
  //    end,
  //    roadType: RoadType.bike,
  //    roadOption: RoadOption(
  //      roadColor: drawColor(rInf.distance, rInf.duration),
  //      roadWidth: 20,
  //    ),
  //  );
//
  //  distTotal += roadInfo.distance!;
  //  timeTotal += roadInfo.duration! / 60;
//
  //  infosBarre = "$distTotal km in $timeTotal min";
  //}
//
  //void placemarkers() {
  //  List<GeoPoint> listMarkers = [];
  //  for (int i = 0; i < widget.points.length; i++) {
  //    listMarkers.add(widget.points[i]);
  //  }
//
  //  markers.add(
  //    StaticPositionGeoPoint(
  //      "places",
  //      const MarkerIcon(
  //        icon: Icon(
  //          Icons.location_on,
  //          size: 50,
  //        ),
  //      ),
  //      listMarkers,
  //    ),
  //  );
  //}
//
  //void snack(String str) {
  //  SnackBar snackBar = SnackBar(
  //    content: Text(
  //      str,
  //      textScaleFactor: 1.5,
  //    ),
  //    duration: const Duration(seconds: 5),
  //  );
//
  //  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //}
//
  //Future<Null> info() async {
  //  return (showDialog(
  //      context: context,
  //      barrierDismissible: true,
  //      builder: (BuildContext context) {
  //        return SimpleDialog(
  //          title: const Text(
  //            "Informations",
  //            style: TextStyle(fontSize: 20, color: Colors.black),
  //            textAlign: TextAlign.center,
  //          ),
  //          children: [
  //            Container(
  //              height: MediaQuery.of(context).size.height / 10,
  //              margin: const EdgeInsets.all(20),
  //              child: Column(
  //                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                children: [
  //                  Text(infosBarre),
  //                ],
  //              ),
  //            ),
  //          ],
  //        );
  //      }));
  //}
//
  //getPointsTries(List ordre) {
  //  List point = [];
//
  //  ordre.forEach((elt) {
  //    if (elt != 0) {
  //      point.add(widget.points[elt - 1]);
  //    }
  //  });
//
  //  return point;
  //}
//
  //getMatriceDist() async {
  //  List<GeoPoint> listPoints = [await controller.myLocation()];
//
  //  widget.points.forEach((elt) {
  //    listPoints.add(elt);
  //  });
//
  //  var Matrice = [];
//
  //  for (int i = 0; i < listPoints.length; i++) {
  //    Matrice.add([]);
  //    for (int j = 0; j < listPoints.length; j++) {
  //      Matrice[i].add([0]);
  //      if (i != j) {
  //        RoadInfo roadInfo = await controller.drawRoad(
  //          listPoints[i],
  //          listPoints[j],
  //          roadType: RoadType.bike,
  //          roadOption: const RoadOption(
  //            roadWidth: 0,
  //          ),
  //        );
  //        Matrice[i][j] = roadInfo.distance;
  //      }
  //    }
  //  }
//
  //  List ordre = await Algorithm(Matrice);
  //  return (ordre);
  //}
//
  //Future<Null> end() async {
  //  return (showDialog(
  //      context: context,
  //      barrierDismissible: false,
  //      builder: (BuildContext context) {
  //        return SimpleDialog(
  //          title: const Text(
  //            "Delivery finished ?",
  //            style: TextStyle(fontSize: 20, color: Colors.black),
  //            textAlign: TextAlign.center,
  //          ),
  //          children: [
  //            Container(
  //              height: MediaQuery.of(context).size.height / 4,
  //              margin: const EdgeInsets.all(20),
  //              child: Column(
  //                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                children: [
  //                  ElevatedButton(
  //                    onPressed: () async {
  //                      print(widget.idLiv);
  //                      print(
  //                          "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
  //                      final supabase = Supabase.instance.client;
  //                      await supabase
  //                          .from('deliveries')
  //                          .update({'status': 'completed'}).match(
  //                              {'id': widget.idLiv});
  //                      Navigator.pushAndRemoveUntil(
  //                        context,
  //                        MaterialPageRoute(
  //                            builder: (context) => DashboardScreen()),
  //                        (Route<dynamic> route) => false,
  //                      );
  //                    },
  //                    style: ElevatedButton.styleFrom(
  //                        backgroundColor: Colors.green),
  //                    child: const Text("Yes"),
  //                  ),
  //                  ElevatedButton(
  //                    onPressed: () {
  //                      Navigator.pop(context);
  //                    },
  //                    style:
  //                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //                    child: const Text("No"),
  //                  ),
  //                ],
  //              ),
  //            ),
  //          ],
  //        );
  //      }));
  //}
//
  //Algorithm(List<dynamic> listPoints) async {
  //  List<int> ordre;
  //  ordre = n_permutation(15, listPoints);
  //  int index_ville_zero = ordre.indexOf(0);
  //  List<int> ordre_depart_ville_zero = [0]
  //    ..addAll(ordre.sublist(index_ville_zero + 1))
  //    ..addAll(ordre.sublist(0, index_ville_zero));
  //  return (ordre_depart_ville_zero);
  //}
//
  //List<int> shuffle(List<int> array) {
  //  var random = Random(); //import 'dart:math';
//
  //  // Go through all elementsof list
  //  for (var i = array.length - 1; i > 0; i--) {
  //    // Pick a random number according to the lenght of list
  //    var n = random.nextInt(i + 1);
  //    var temp = array[i];
  //    array[i] = array[n];
  //    array[n] = temp;
  //  }
  //  return array;
  //}
//
  //longueur(List ordre, List<dynamic> listPoints) {
  //  double d = 0;
  //  for (int i = 0; i < ordre.length;) {
  //    if (i == 0) {
  //      d += double.parse(
  //          listPoints[ordre[ordre.length - 1]][ordre[0]].toString());
  //    } else {
  //      d += double.parse(listPoints[ordre[i - 1]][ordre[i]].toString());
  //    }
  //    return d;
  //  }
  //}
//
  //List<int> permutation_rnd(
  //    List<int> ordre, int minuteur, List<dynamic> listPoints) {
  //  int k = 0;
  //  int l = 0;
  //  List<int> r = [];
  //  double t;
  //  double d = 0;
  //  double d0;
  //  int it = 1;
  //  List<int> ordre2 = ordre;
  //  d = longueur(ordre, listPoints);
  //  d0 = d + 1;
//
  //  while (d < d0 || it < minuteur) {
  //    it += 1;
  //    d0 = d;
  //    for (int i = 1; i < (ordre.length) - 1; i++) {
  //      for (int j = i + 2; j < (ordre.length) + 1; j++) {
  //        k = 1 + (Random().nextInt(ordre.length - 1));
  //        l = (k + 1) + (Random().nextInt(ordre.length - (k)));
  //        for (int i = 0; i < (l - k); i++) {
  //          r.add(0);
  //        }
  //        List.copyRange(r, 0, ordre, k, l);
  //        r = List.from(r.reversed);
  //        List.copyRange(ordre2, 0, ordre, 0, k);
  //        List.copyRange(ordre2, k, r, 0, r.length);
  //        List.copyRange(ordre2, l, ordre, l, ordre.length);
  //        r.clear();
  //        t = longueur(ordre2, listPoints);
  //        if (t < d) {
  //          d = t;
  //          ordre = ordre2;
  //        }
  //      }
  //    }
  //  }
  //  return ordre;
  //}
//
  //List<int> n_permutation(int minuteur, List<dynamic> listPoints) {
  //  List<int> ordre =
  //      List<int>.generate(listPoints.length, (int index) => index);
  //  List<int> bordre = [];
  //  double d0 = 0;
  //  double d;
  //  ordre.forEach((elt) {
  //    bordre.add(elt);
  //  });
//
  //  d0 = longueur(ordre, listPoints);
  //  for (int i = 0; i < 50; i++) {
  //    ordre = shuffle(ordre);
  //    ordre = permutation_rnd(ordre, minuteur, listPoints);
  //    d = longueur(ordre, listPoints);
  //    if (d < d0) {
  //      d0 = d;
  //      bordre.clear();
  //      ordre.forEach((elt) {
  //        bordre.add(elt);
  //      });
  //    }
  //  }
  // return bordre;
  //}
}

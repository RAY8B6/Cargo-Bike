import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'package:application_cargo/main.dart';

import '../dashboard.dart';


class Home_Map extends StatefulWidget {
  const Home_Map({super.key, required this.title});
  final String title;

  @override
  State<Home_Map> createState() => _Home_Map();
}

class _Home_Map extends State<Home_Map> {

  late MapController controller;

  List<StaticPositionGeoPoint> markers=[
    StaticPositionGeoPoint("places", const MarkerIcon(icon: Icon(Icons.location_on, size: 50,),),
      [
        GeoPoint(latitude: 10.0,longitude: 10.0),
        GeoPoint(latitude: 48,longitude: 2)
      ],
    ),
    StaticPositionGeoPoint("train", const MarkerIcon(icon: Icon(Icons.train, size: 50,),),
      [
        GeoPoint(latitude: 48.08534240722656, longitude: -0.755290150642395),
        GeoPoint(latitude: 45.000001, longitude: 45.00001),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    controller = MapController.cyclOSMLayer(
      initMapWithUserPosition: true,
    );
  }

  double step=4000;
  String distance="Not yet";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const DashboardScreen()));
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white,),
            ),
            IconButton(
                onPressed: getLocation,
                icon: const Icon(Icons.my_location, size: 30)
            ),
            IconButton(
                onPressed: (){
                  zoomOut();
                  print("zoom out");
                },
                icon: const Icon(Icons.zoom_out, size: 30)
            ),
            IconButton(
                onPressed: (){
                  zoomIn();
                  print("zoom in");
                },
                icon: const Icon(Icons.zoom_in, size: 30,)
            ),
            IconButton(
                onPressed: (){
                  drawRoad();
                },
                icon: const Icon(Icons.add_road, size: 30)
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: (
                OSMFlutter(
                  showContributorBadgeForOSM: true,
                  showZoomController: true,
                  controller: controller,
                  initZoom: 18,
                  trackMyPosition: true,
                  userLocationMarker:  UserLocationMaker(
                    personMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.location_history,
                        size: 75,
                      ),
                    ),
                    directionArrowMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.keyboard_double_arrow_right,
                        size: 75,
                      ),

                    ),
                  ),
                  markerOption: MarkerOption(
                    defaultMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 56,
                      ),
                    ),
                    advancedPickerMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.location_on_outlined,
                      ),
                    ),
                  ),
                  onMapIsReady: (bool value) async {
                    if (value) {
                      Future.delayed(const Duration(seconds: 1), () async {
                        getLocation();
                      });

                    }
                  },
                  staticPoints: markers,
                  roadConfiguration: RoadConfiguration(
                    //roadColor: Colors.blue,
                      startIcon: const MarkerIcon(icon: Icon(Icons.flag_circle_rounded, size: 50, color: Colors.amber,)),
                      endIcon: const MarkerIcon(icon: Icon(Icons.star)),
                      middleIcon: const MarkerIcon(icon: Icon(Icons.ac_unit, size: 73, color: Colors.red,),)
                  ),
                  onLocationChanged: (GeoPoint geopoint){
                    setState(() {
                      step=geopoint.longitude;
                    });
                  },
                  /*
              staticPoints: [
                StaticPositionGeoPoint("line 1", const MarkerIcon(icon: Icon(Icons.train,color: Colors.green,size: 48,),),
                  [
                    GeoPoint(latitude: 47.4333594, longitude: 8.4680184),
                    GeoPoint(latitude: 47.4317782, longitude: 8.4716146),
                  ],
                ),
                StaticPositionGeoPoint("line 2",const MarkerIcon(icon: Icon(Icons.train,color: Colors.red,size: 48,),),
                  [
                    GeoPoint(latitude: 47.4433594, longitude: 8.4680184),
                    GeoPoint(latitude: 47.4517782, longitude: 8.4716146),
                  ],
                )
              ],*/
                )
            ),
          ),
          BottomAppBar(
              child: Row(
                children: [
                  Text("$distance"),
                ],
              )
          ),
        ],
      ),
    );
  }


  getLocation() async {
    await controller.currentLocation();
  }

  zoomIn() async {
    await controller.setZoom(stepZoom: 1);
  }

  zoomOut() async {
    await controller.setZoom(stepZoom: -1);
  }

  drawRoad() async {
    /*
    List<GeoPoint> tablGeo=[GeoPoint(latitude: 48.08534240722656, longitude: -0.755290150642395),GeoPoint(latitude: 48.8588897, longitude: 2.320041,),GeoPoint(latitude: 41.3608556, longitude: 2.1110075,)];

    print(tablGeo.length);
    for (int i =0; i<tablGeo.length; i++){
      if (i==0){
        GeoPoint geoPoint = await controller.myLocation();
        await controller.drawRoad(tablGeo[i], geoPoint);
      } else{
        await controller.drawRoad(tablGeo[i], tablGeo[i++]);
      }
    }*/

    List<GeoPoint> tablGeo=[GeoPoint(latitude: 41.361912, longitude: 2.11422),GeoPoint(latitude: 41.379131, longitude: 2.12014,),GeoPoint(latitude: 41.40319, longitude: 2.17484,)];

    for (int i =0; i<tablGeo.length; i++){
      if (i==0){
        GeoPoint geoPoint = await controller.myLocation();
        draw(geoPoint, tablGeo[i], i);
      } else{
        draw(tablGeo[i], tablGeo[i-1], i);
      }
    }

    /*
    GeoPoint geoPoint = await controller.myLocation();
    await controller.drawRoad(GeoPoint(latitude: 48.08534240722656, longitude: -0.755290150642395), geoPoint);
    await controller.drawRoad(GeoPoint(latitude: 48.8588897, longitude: 2.320041,), GeoPoint(latitude: 48.08534240722656, longitude: -0.755290150642395));
    await controller.drawRoad(GeoPoint(latitude: 41.3608556, longitude: 2.1110075,), GeoPoint(latitude: 48.8588897, longitude: 2.320041,));
    */
  }

  draw (GeoPoint start, GeoPoint end, iteration) async {
    RoadInfo roadInfo = await controller.drawRoad(
      start,
      end,
      roadType: RoadType.bike,
      roadOption: RoadOption(
        roadColor: Colors.red[(iteration+1)*300],
      ),
    );

    setState((){
      distance="${roadInfo.distance.toString()}km in ${roadInfo.duration}s";
    });
  }


}

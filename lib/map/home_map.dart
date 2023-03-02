import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


import '../dashboard.dart';

import 'package:flutter/services.dart';

import 'package:supabase_flutter/supabase_flutter.dart';




class Home_Map extends StatefulWidget {
  const Home_Map({super.key, required this.title, required this.points, required this.idLiv});
  final String title;
  final List<GeoPoint> points;
  final int idLiv;

  @override
  State<Home_Map> createState() => _Home_Map();
}

class _Home_Map extends State<Home_Map> {

  late MapController controller;
  List<StaticPositionGeoPoint> markers=[];

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: true,
    );
    placemarkers();
  }

  double distTotal=0;
  double timeTotal=0;

  double step=4000;
  String infosBarre="Not yet";

  int currentPoint=1;

  List points=[];

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
                onPressed: (){
                  getLocation();
                  controller.setZoom(zoomLevel: 18);
                },
                icon: const Icon(Icons.my_location, size: 30)
            ),
            IconButton(
                onPressed: () async {
                  List ordre = await getMatriceDist();
                  points = await getPointsTries(ordre);
                  drawRoads(points);
                },
                icon: const Icon(Icons.add_road, size: 30)
            ),
            IconButton(
                onPressed: (){
                  drawMyRoad(points);
                },
                icon: const Icon(Icons.play_arrow_sharp, size: 30,)),
            IconButton(
                onPressed: () {
                  info();
                },
                icon: const Icon(Icons.info_outline_rounded, size: 30,)
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: (
                OSMFlutter(
                  mapIsLoading: const Center(child: CircularProgressIndicator()),
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
                )
            ),
          ),
          BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Point $currentPoint/${widget.points.length}"),
                  OutlinedButton(
                      onPressed: (){
                        setState(() {
                          if (currentPoint>1){
                            currentPoint--;
                            drawMyRoad(points);
                          }
                        });
                      },
                      child: const Text("Previous Point")
                  ),
                  OutlinedButton(
                      onPressed: (){
                        setState(() {
                          if (currentPoint<widget.points.length){
                            currentPoint++;
                            drawMyRoad(points);
                          } else {
                              end();
                          }
                        });
                      },
                      child: const Text("Next Point")
                  ),
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

  drawRoads(List tablGeo) async {

    timeTotal=0;
    distTotal=0;


    for (int i =0; i<tablGeo.length; i++){
      if (i==0){
        GeoPoint geoPoint = await controller.myLocation();
        draw(geoPoint, tablGeo[i]);
      } else{
        draw(tablGeo[i], tablGeo[i-1]);
      }
    }


    await Future.delayed(const Duration(seconds: 1));
    snack(infosBarre);
  }

  drawMyRoad(List points) async {
    GeoPoint myLocation = await controller.myLocation();

    RoadInfo roadInfo = await controller.drawRoad(myLocation, points[currentPoint-1], roadType: RoadType.bike,roadOption: const RoadOption(roadColor: Colors.red,roadWidth: 20, ),);

    setState(() {
      infosBarre="Il reste: ${roadInfo.distance.toString()}km in ${((roadInfo.duration)!/60).floor()}min";
    });
  }

  draw (GeoPoint start, GeoPoint end) async {
    RoadInfo roadInfo = await controller.drawRoad(
      start,
      end,
      roadType: RoadType.bike,
      roadOption: const RoadOption(
        roadColor: Colors.red,
        roadWidth: 20,
      ),
    );

    distTotal+=roadInfo.distance!;
    timeTotal+=roadInfo.duration!/60;

    infosBarre="$distTotal km in $timeTotal min";

  }

  void placemarkers(){
    List<GeoPoint> listMarkers=[];
    for (int i=0; i<widget.points.length;i++){
      listMarkers.add(widget.points[i]);
    }

    markers.add(StaticPositionGeoPoint("places", const MarkerIcon(icon: Icon(Icons.location_on, size: 50,),), listMarkers,),);
  }



  void snack(String str){
    SnackBar snackBar = SnackBar(
      content: Text(str, textScaleFactor: 1.5,),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<Null> info() async {
    return(showDialog(
        context: context,
        barrierDismissible: true,
        builder:(BuildContext context){
          return SimpleDialog(
            title: const Text("Informations", style: TextStyle(fontSize: 20, color: Colors.black), textAlign: TextAlign.center,),

            children: [
              Container(
                height: MediaQuery.of(context).size.height/4,
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(infosBarre),
                  ],
                ),
              ),
            ],
          );
        }
    ));
  }

  getPointsTries(List ordre) {
    List point=[];

    ordre.forEach((elt) {
      if (elt!=0){
        point.add(widget.points[elt-1]);
      }
    });

    return point;

  }

  getMatriceDist () async {
    List<GeoPoint> listPoints = [ await controller.myLocation()];

    widget.points.forEach((elt) {
      listPoints.add(elt);
    });

    var Matrice=[];

    for (int i =0; i<listPoints.length;i++){
      Matrice.add([]);
      for (int j=0; j<listPoints.length;j++){
        Matrice[i].add([0]);
        if(i!=j){

          RoadInfo roadInfo = await controller.drawRoad(listPoints[i],listPoints[j],roadType: RoadType.bike,roadOption: const RoadOption(roadWidth: 0,),);
          Matrice[i][j]=roadInfo.distance;
        }
      }
    }

    List ordre = await Algorithm(Matrice);
    return (ordre);

  }

  Future<Null> end() async {
    return(showDialog(
        context: context,
        barrierDismissible: false,
        builder:(BuildContext context){
          return SimpleDialog(
            title: const Text("Delivery finished ?", style: TextStyle(fontSize: 20, color: Colors.black), textAlign: TextAlign.center,),

            children: [
              Container(
                height: MediaQuery.of(context).size.height/4,
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          print(widget.idLiv);
                          print("oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
                          final supabase = Supabase.instance.client;
                          await supabase.from('deliveries').update({'status' : 'completed'}).match({'id' : widget.idLiv});
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => DashboardScreen()),
                                (Route<dynamic> route) => false,
                          );
                        },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text("Yes"),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("No"),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    ));
  }







  Algorithm(List <dynamic> listPoints) async {

    List<int> ordre;
    ordre = n_permutation(15, listPoints);
    int index_ville_zero = ordre.indexOf(0);
    List<int> ordre_depart_ville_zero = [0]
      ..addAll(ordre.sublist(index_ville_zero + 1))
      ..addAll(ordre.sublist(0, index_ville_zero));
    return(ordre_depart_ville_zero);

  }



  List<int> shuffle(List<int> array) {
    var random = Random(); //import 'dart:math';

    // Go through all elementsof list
    for (var i = array.length - 1; i > 0; i--) {

      // Pick a random number according to the lenght of list
      var n = random.nextInt(i + 1);
      var temp = array[i];
      array[i] = array[n];
      array[n] = temp;
    }
    return array;
  }


  longueur(List ordre, List <dynamic> listPoints){
    double d = 0;
    for(int i = 0; i < ordre.length; i++){
      if(i == 0){
        d += double.parse(listPoints[ordre[ordre.length - 1]][ordre[0]].toString());
      }
      else{
        d += double.parse(listPoints[ordre[i-1]][ordre[i]].toString());
      }
      return d;
    }
  }


  List<int> permutation_rnd(List<int> ordre, int minuteur, List <dynamic> listPoints){

    int k = 0;
    int l = 0;
    List<int> r = [];
    double t;
    double d = 0;
    double d0;
    int it = 1;
    List<int> ordre2 = ordre;
    d = longueur(ordre, listPoints);
    d0 = d+1;

    while(d < d0 || it < minuteur){
      it += 1;
      d0 = d;
      for(int i = 1; i < (ordre.length)-1; i++){
        for(int j = i+2; j < (ordre.length)+1; j++){
          k = 1 + ( Random().nextInt(ordre.length - 1));
          l = (k+1) + ( Random().nextInt(ordre.length - (k)));
          for(int i = 0; i < (l-k); i++){
            r.add(0);
          }
          List.copyRange(r, 0, ordre, k, l);
          r = List.from(r.reversed);
          List.copyRange(ordre2, 0, ordre, 0, k);
          List.copyRange(ordre2, k, r, 0, r.length);
          List.copyRange(ordre2, l, ordre, l, ordre.length);
          r.clear();
          t = longueur(ordre2, listPoints);
          if(t < d){
            d = t;
            ordre = ordre2;
          }
        }
      }
    }
    return ordre;
  }

  List<int> n_permutation(int minuteur, List <dynamic> listPoints){
    List<int> ordre = List<int>.generate(listPoints.length , (int index) => index);
    List<int> bordre = [];
    double d0 = 0;
    double d;
    ordre.forEach((elt){
      bordre.add(elt);
    });

    d0 = longueur(ordre, listPoints);
    for(int i = 0; i < 50; i++){
      ordre = shuffle(ordre);
      ordre = permutation_rnd (ordre, minuteur, listPoints);
      d = longueur(ordre, listPoints);
      if(d < d0){
        d0 = d;
        bordre.clear();
        ordre.forEach((elt){
          bordre.add(elt);
        });
      }
    }
    return bordre;
  }

















}

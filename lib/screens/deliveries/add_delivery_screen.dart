// ignore_for_file: unrelated_type_equality_checks

//import 'dart:ffi';
//import 'dart:typed_data';

//import 'package:application_cargo/customize_profile.dart';
import 'package:flutter/material.dart';
import '../../globals/color.dart' as color;
import 'deliveries_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

TextEditingController deliveryIdController = TextEditingController();
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController packageIdController = TextEditingController();
TextEditingController deliveryAddressController = TextEditingController();

String deliveryIdState = "";
String customerState = "";
String packageIdState = "";

class Add_Delivery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Add delivery ",
      home: AddDeliveryPage(),
    );
  }
}

class AddDeliveryPage extends StatefulWidget {
  @override
  _AddDeliveryPageState createState() => _AddDeliveryPageState();
}

class _AddDeliveryPageState extends State<AddDeliveryPage> {
  Future<List<double>> getCoordinates(String address) async {
    final apiUrl =
        'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1';

    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);

    if (data.isNotEmpty) {
      final lat = double.parse(data[0]['lat']);
      final lng = double.parse(data[0]['lon']);
      return [lat, lng];
    } else {
      // ignore: use_build_context_synchronously
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to find the address"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok"))
          ],
        ),
      );
      throw Exception(
          'Failed to retrieve coordinates from OpenStreetMap Nominatim API.');
    }
  }

  // ignore: duplicate_ignore
  Future addPackageToDelivery({required BuildContext context}) async {
    final supabase = Supabase.instance.client;
    String error = "";

    if (deliveryIdController.text.isEmpty ||
        deliveryAddressController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty) {
      if (deliveryIdController.text.isEmpty) {
        error = "No delivery Id entered";
      }
      if (deliveryAddressController.text.isEmpty) {
        error = "No delivery address entered";
      }
      if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
        error = "Wrong customers informations";
      }
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text(error),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok"))
          ],
        ),
      );
      throw Exception("Error");
    }

    var delivery = await supabase
        .from('deliveries')
        .select('id')
        .eq('id', deliveryIdController.text);
    if (delivery.toString() != "[]") {
      deliveryIdState = "Exist";
    } else {
      deliveryIdState = "Doesn't exist";
    }

    var customer = await supabase
        .from('customers')
        .select('id, first_name, last_name')
        .eq('first_name', firstNameController.text)
        .eq('last_name', lastNameController.text);
    if (customer.toString() != "[]") {
      customerState = "Exist";
    } else {
      customerState = "Doesn't exist";
    }

    var package = await supabase
        .from('packages')
        .select('id')
        .eq('id', packageIdController.text);
    if (package.toString() != "[]") {
      error = "Package Id already taken";
      packageIdState = "Exist";
      // ignore: use_build_context_synchronously
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text(error),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok"))
          ],
        ),
      );
      throw Exception("Error");
    } else {
      packageIdState = "Doesn't exist";
    }

    final coord = await getCoordinates(deliveryAddressController.text);
    final List<double> coordinates = coord;

    if (packageIdState == "Doesn't exist" &&
        deliveryIdController.text.isNotEmpty &&
        deliveryAddressController.text.isNotEmpty) {
      if (customerState == "Doesn't exist") {
        await supabase.from('customers').insert({
          'first_name': firstNameController.text,
          "last_name": lastNameController.text
        });
      }
      if (deliveryIdState == "Doesn't exist") {
        await supabase.from('deliveries').insert({
          'id': deliveryIdController.text,
          "nb_customers": 1,
          "nb_packages": 1,
          "points": [coordinates],
          "status": "Available"
        });
      } else {
        List<dynamic> addresses = await supabase
            .from('deliveries')
            .select('points')
            .eq('id', deliveryIdController.text);
        var customers = await supabase
            .from('deliveries')
            .select('nb_customers')
            .eq('id', deliveryIdController.text);
        var packages = await supabase
            .from('deliveries')
            .select('nb_packages')
            .eq('id', deliveryIdController.text);
        int value_packages = packages[0]['nb_packages'];
        int value_customers = customers[0]['nb_customers'];
        List<dynamic> value_points = addresses[0]['points'];
        value_points.add(coordinates);
        await supabase.from('deliveries').update({
          'nb_customers': value_customers += 1,
          'nb_packages': value_packages += 1,
          'points': value_points
        }).match({'id': deliveryIdController.text});
      }

      await supabase.from('packages').insert({
        'id': packageIdController.text,
        "delivery_id": deliveryIdController.text,
        "customer_id": 3,
        "delivery_address": deliveryAddressController.text
      });

      // ignore: use_build_context_synchronously
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Success"),
          content: Text("The delivery was successfully created or updated"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => DeliveryPage())),
                child: Text("Ok"))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        actionsIconTheme: IconThemeData(),
        iconTheme: IconThemeData(),
        title: const Text(
          "Add a new package",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.onSecondary,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Delivery information",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: color.appColor(),
                            ),
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            controller: deliveryIdController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              labelText: "Delivery number",
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: color.appColor(), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: color.appColor(), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: color.appColor(), width: 1),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 10),
                Card(
                    elevation: 2,
                    color: Theme.of(context).colorScheme.onSecondary,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Customer information",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: color.appColor(),
                                ),
                              ),
                              SizedBox(height: 25),
                              TextFormField(
                                controller: firstNameController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  labelText: "First name",
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: color.appColor(), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: color.appColor(), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: color.appColor(), width: 1),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              TextFormField(
                                controller: lastNameController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  labelText: "Last name",
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: color.appColor(), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: color.appColor(), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: color.appColor(), width: 1),
                                  ),
                                ),
                              ),
                            ]))),
                SizedBox(height: 10),
                Card(
                    elevation: 2,
                    color: Theme.of(context).colorScheme.onSecondary,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              "Package information",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: color.appColor(),
                              ),
                            ),
                            SizedBox(height: 25),
                            TextFormField(
                              controller: packageIdController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                labelText: "Package number",
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: color.appColor(), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: color.appColor(), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: color.appColor(), width: 1),
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            TextFormField(
                              controller: deliveryAddressController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                hintText:
                                    'N° and name of street, postal code, province',
                                labelText: "Delivery address",
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: color.appColor(), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: color.appColor(), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: color.appColor(), width: 1),
                                ),
                              ),
                            ),
                          ],
                        ))),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    addPackageToDelivery(context: context);
                  },
                  child: Text(
                    "Add a new package",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    "Note : If the delivery Id does not exist, it will create a new delivery with all the information entered above.",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

//import 'dart:io';

import 'package:flutter/material.dart';
import 'deliveries_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../globals/color.dart' as color;

TextEditingController deliveryIdController = TextEditingController();
TextEditingController deliveryNbCustomersController = TextEditingController();
String Id = "";
String Nb_Customers = "";
String Status = "";
List<String> list = <String>['available', 'completed'];

class Edit_Delivery extends StatelessWidget {
  int number = 0;
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Edit delivery page",
      home: EditDeliveryPage(
        index: number,
      ),
    );
  }
}

class EditDeliveryPage extends StatefulWidget {
  @override
  EditDeliveryPage({super.key, required this.index});
  final int index;
  _EditDeliveryPageState createState() => _EditDeliveryPageState();
}

class _EditDeliveryPageState extends State<EditDeliveryPage> {
  Future<List<String>> getUserData({required BuildContext context}) async {
    List<String> result = [];
    final supabase = Supabase.instance.client;
    var deliveryInfos = await supabase
        .from('deliveries')
        .select('id, nb_customers, nb_packages, points, status')
        .eq('id', (widget.index).toString());
    if (deliveryInfos.toString() != "[]") {
      Id = deliveryInfos[0]['id'].toString();
      Nb_Customers = deliveryInfos[0]['nb_customers'].toString();
      Status = deliveryInfos[0]['status'];
      result.add(Id);
      result.add(Nb_Customers);
      result.add(Status);
    }
    return result;
  }

  Future updateDelivery({required BuildContext context}) async {
    getUserData(context: context);
    final supabase = Supabase.instance.client;
    if (deliveryNbCustomersController.text.isEmpty) {
      deliveryNbCustomersController.text = _hintNbCustomersText;
    }
    debugPrint(" delivery id : " +
        widget.index.toString() +
        " nb customer : " +
        deliveryNbCustomersController.text +
        " status " +
        dropdownValue);
    try {
      await supabase.from("deliveries").update({
        'nb_customers': deliveryNbCustomersController.text,
        'status': dropdownValue
      }).match({'id': (widget.index).toString()});
      debugPrint('Updated');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delivery information'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Delivery updated successfully."),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DeliveryPage()));
                  },
                ),
              ],
            );
          });
    } on AuthException catch (e) {
      debugPrint("Update error : " + e.message);
    }
  }

  String _hintIdText = "";
  String _hintNbCustomersText = "";

  String dropdownValue = list.first;

  void changeHintText(List<String> list) {
    if (this.mounted && list.isNotEmpty) {
      setState(() {
        _hintIdText = list[0];
        _hintNbCustomersText = list[1];
        dropdownValue = list[2];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hintIdText == "") {
      Future<List<String>> result = getUserData(context: context);

      result.then((deliveryData) {
        print(deliveryData);
        this.changeHintText(deliveryData);
      });
    }

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
          "Edit a selected delivery",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Delivery informations",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        enabled: false,
                        controller: deliveryIdController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          hintText: "Id : $_hintIdText",
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: color.appColor(), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: color.appColor(), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: color.appColor(), width: 1),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Number of customers to deliver",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: deliveryNbCustomersController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          hintText: _hintNbCustomersText,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: color.appColor(), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: color.appColor(), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: color.appColor(), width: 1),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Status of the delivery",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                          ),
                          SizedBox(width: 20),
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: color.appColor(),
                            ),
                            elevation: 16,
                            style: TextStyle(color: color.appColor()),
                            underline: Container(
                              height: 2,
                              color: color.appColor(),
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updateDelivery(context: context);
                },
                child: Text(
                  "Apply modifications",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

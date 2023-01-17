import 'package:application_cargo/main.dart';
import 'package:application_cargo/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

const List<String> listOfDelivery = <String>['First Delivery', 'Second Delivery'];
const List<String> firstDelivery = <String>["Customers : 4", "Packages to deliver : 9", "Estimated time : 28min", "Total distance to travel : 6km"];
const List<String> secondDelivery = <String>["Customers : 6", "Packages to deliver : 13", "Estimated time : 34min", "Total distance to travel : 7km"];

class DeliveryScreen extends StatelessWidget{
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context){
    return const DeliveryExample();
  }
}

class DeliveryExample extends StatefulWidget{
  const DeliveryExample({super.key});

  @override
  State<DeliveryExample> createState() => _DeliveryExampleState();
}

class _DeliveryExampleState extends State<DeliveryExample>{
  String dropdownValue = listOfDelivery.first;
  List<String> listToShow = firstDelivery;

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
        title: const Text("Delivery screen", style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Select a delivery : "),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.blue),
                  underline: Container(
                    height: 2,
                    color: Colors.indigo,
                  ),
                  onChanged: (String? value){
                    dropdownValue = value!;
                    setState(() {
                      dropdownValue = value;
                      if(dropdownValue == "First Delivery"){
                        listToShow = firstDelivery;
                      }else{
                        listToShow = secondDelivery;
                      }
                    });
                  },
                  items: listOfDelivery.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Card(
              child: Column(
                  children: [
                    Text(dropdownValue + " informations", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                    const SizedBox(height: 20.0),
                    Text(listToShow[0]),
                    Text(listToShow[1]),
                    Text(listToShow[2]),
                    Text(listToShow[3]),
                  ],
              ),
            ),
            const SizedBox(height: 80.0),
            MaterialButton(
              onPressed: () {
                //Start delivery
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
          ],
        ),
      ),
    );
  }
}
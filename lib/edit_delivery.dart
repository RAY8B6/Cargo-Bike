import 'package:flutter/material.dart';
import 'startDeliveryScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Edit_Delivery extends StatelessWidget {
  @override
  int number = 0;
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Edit delivery page",
      home: EditDeliveryPage(index: number,),
    );
  }
}

class EditDeliveryPage extends StatefulWidget {

  @override
  const EditDeliveryPage({super.key, required this.index});
  final int index;
  _EditDeliveryPageState createState() => _EditDeliveryPageState();
}

class _EditDeliveryPageState extends State<EditDeliveryPage> {

  Future getUserData({required BuildContext context}) async {
    final supabase = Supabase.instance.client;
    var deliveryInfos = await supabase.from('deliveries').select('id, nb_customers, nb_packages, time, distance, points, status').eq('id', widget.index);
  }


  @override
  Widget build(BuildContext context) {

    getUserData(context: context);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.arrow_back, color: Colors.white,),
          onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> DeliveryPage()));
          },
        ),
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text("Edit selected delivery", style: TextStyle(color: Colors.white),),
      ),
    );
  }

}
import 'package:application_cargo/main.dart';
import 'package:application_cargo/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

int _selectedIndex = 0;

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  final _future = Supabase.instance.client
      .from('deliveries')
      .select<List<Map<String, dynamic>>>();

  @override
  Widget build(BuildContext context) {
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
                                    "\nEstimated time : ${delivery['time']}"
                                    "\nTotal distance to travel : ${delivery['distance']}km"),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                            ),
                            );
                          }),
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
                  )
                );
            }
          ),
    );
  }
}
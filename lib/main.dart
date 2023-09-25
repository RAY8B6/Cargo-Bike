// ignore_for_file: library_private_types_in_public_api

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
//import 'package:application_cargo/screens/dashboard_screen.dart';
import 'package:application_cargo/screens/users/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'globals/color.dart' as color;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*await dotenv.load(fileName: ".env");

  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'].toString(),
      anonKey: dotenv.env['SERVICE_KEY'].toString());*/

  await Supabase.initialize(
      url: "https://eizvcrbyrkfwzqeobqwm.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpenZjcmJ5cmtmd3pxZW9icXdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzM5NjEzODksImV4cCI6MTk4OTUzNzM4OX0.aTojsRh_3iNN4IN_6VAOy8rfS7IHKmxxBuC06G6LzkE");
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

String screenToDisplay = "";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "B-MoveOn",
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: color.appColor(), brightness: Brightness.light),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                backgroundColor: color.appColor(),
                foregroundColor: Colors.white,
                minimumSize: Size(130, 25),
                padding: EdgeInsets.all(15)),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: color.appColor(),
              fixedSize: Size(250, 25),
              side: BorderSide(color: color.appColor()),
            ),
          ),
          iconTheme: IconThemeData(color: color.appColor()),
          cardTheme: CardTheme(
            elevation: 2,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
          inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(
                  color: color.appColor().withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
              labelStyle: TextStyle(color: color.appColor(), fontSize: 15)),
          iconButtonTheme: IconButtonThemeData(
            style: IconButton.styleFrom(foregroundColor: Colors.white),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              foregroundColor: Colors.white,
              backgroundColor: color.appColor(),
              sizeConstraints: BoxConstraints(minWidth: 25, minHeight: 25),
              iconSize: 17,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60))),
          appBarTheme: AppBarTheme(
              backgroundColor: color.appColor().withOpacity(0.75),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20))),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.scale(
      duration: Duration(milliseconds: 4000),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 201, 205, 170),
          Color.fromARGB(255, 191, 105, 105),
          Color.fromARGB(255, 53, 70, 165)
        ],
      ),
      childWidget: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: color.appColor(),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/b-moveon.png"),
                      fit: BoxFit.fill)),
            ),
            Container(
              child: CircularProgressIndicator(),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bienvenue sur",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        " B-MoveOn.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Naviguez en toute simplicité.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      defaultNextScreen: LoginScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    if (session != null) {
      debugPrint("session not null§('y(yrtyryryrNNNOT NUULLLLLLLLL!!!!!!");
      //Navigator.of(context).pushReplacement(
      //    MaterialPageRoute(builder: (context) => const DashboardScreen()));
      screenToDisplay = "dashboard";
    } else {
      debugPrint("session null");
      screenToDisplay = "login";

      //Navigator.of(context).pushReplacement(
      //    MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:application_cargo/screens/dashboard_screen.dart';
import 'package:application_cargo/screens/splash_screen.dart';
//import 'package:application_cargo/screens/splash_screen.dart';
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
      home: HomePage(),
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
      debugPrint("session not null");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()));
    } else {
      debugPrint("session null");

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

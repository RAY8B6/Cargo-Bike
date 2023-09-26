import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:application_cargo/screens/users/login_screen.dart';
import 'package:flutter/material.dart';
import '../globals/color.dart' as color;

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

import 'package:application_cargo/RegisterScreen.dart';
import 'package:application_cargo/dashboard.dart';
import 'package:application_cargo/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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

  //Initialize Supabase App
  Future<SupabaseClient> _initializeSupabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Supabase.initialize(
        url: "https://eizvcrbyrkfwzqeobqwm.supabase.co",
        anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpenZjcmJ5cmtmd3pxZW9icXdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzM5NjEzODksImV4cCI6MTk4OTUzNzM4OX0.aTojsRh_3iNN4IN_6VAOy8rfS7IHKmxxBuC06G6LzkE"
    );
    final supabase = Supabase.instance.client;
    return supabase;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: _initializeSupabase(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return LoginScreen();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{


  //Login function
  static Future<bool> loginUsingEmailPassword({required String email, required String password, required BuildContext context}) async{
    final supabase = Supabase.instance.client;
    bool login = false;
    try{
      await supabase.auth.signInWithPassword(
          email: email,
          password: password
      );
      login = true;
    } on AuthException catch (e){
      if(e.message == "user-not-found"){
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Error"),
              content: const Text("Incorrect email or password"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, "Ok"),
                    child: const Text("Ok"))
              ],
            ),
        );
      }
      if(e.message == "wrong-password"){
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Incorrect email or password"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, "Ok"),
                  child: const Text("Ok"))
            ],
          ),
        );
      }
      print(e.message);
    }

    return login;
  }

  @override
  Widget build(BuildContext context) {
    //create the textfiled controller
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Padding(
        padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cargo Bike",
              textAlign: TextAlign.center,
              style:TextStyle(
                color: Colors.black,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Login page",
              style: TextStyle(
                color: Colors.black,
                fontSize: 44.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 44.0,
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            GestureDetector(
              child: const Text(
                "Forgot Password ?",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff3a57e8),
                ),
              ),
              onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ForgotPasswordScreen()))
            ),
            const SizedBox(
              height: 70.0,
            ),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Color(0xff3a57e8),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                onPressed: () async {
                  bool login = await loginUsingEmailPassword(email: emailController.text, password: passwordController.text, context: context);
                  print(login);
                  if(login == true) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> DashboardScreen()));
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Color(0xff3a57e8),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> RegisterScreen()));
                },

                child: const Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

}
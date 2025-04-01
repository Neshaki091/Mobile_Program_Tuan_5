import 'package:flutter/material.dart';
import 'auth_services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "homepage.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthServices())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: SignIn(),
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthServices>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backGround.png"),
            alignment: Alignment.topRight, // Điều chỉnh kích thước ảnh
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Image.asset(
                "assets/logoUTH.png",
                width: 202,
                height: 197,
                scale: 0.75,
              ),
              SizedBox(height: 20),
              Text(
                "SmartTasks",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "A simple and efficient to-do app",
                style: TextStyle(color: Colors.blue),
              ),
              SizedBox(height: 100),
              Text("Welcome", style: TextStyle(fontSize: 16)),
              Text("Ready to explore? Login to get started"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    User? user = await authProvider.signInWithGoogle();
                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đăng nhập thất bại, thử lại!")),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/logoGoogle.png"),
                      SizedBox(width: 10),
                      Text("SIGN IN WITH GOOGLE"),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 140),
                child: Text("© UTHSmartTasks"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

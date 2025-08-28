import 'dart:async';
import 'package:digivity_admin_app/AuthenticationUi/CustomAnimatedWidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () async {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLogin') ?? false;

      if (isLoggedIn) {
        context.goNamed('dashboard');
      } else {
        context.goNamed('schoolCodeVerification');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:AnimatedContainer(duration: Duration(seconds: 3),
          child:CustomAnimatedWidget(
            beginOffset: Offset(0, 1),
            duration: Duration(seconds: 3),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logos/digivity_logo.png',
                        height: 250,
                        width: 200,
                      ),
                      SizedBox(height: 0),
                      Text(
                        "DIGIVITY ADMIN APP",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Empowering Education Through Innovation"),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child:Image.asset('assets/logos/bottom1.png'))
              ],
            ),),
        )
    );
  }
}


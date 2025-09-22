import 'package:digivity_admin_app/Components/BouncingBubble.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _fadeIn;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();

    // Logo fade-in
    _logoController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeIn = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);
    _logoController.forward();

    // Progress animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final prefs = await SharedPreferences.getInstance();
        final isLoggedIn = prefs.getBool('isLogin') ?? false;

        if (mounted) {
          if (isLoggedIn) {
            context.goNamed('dashboard');
          } else {
            context.goNamed('schoolCodeVerification');
          }
        }
      }
    });

    _progressController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  // Floating bubbles


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Gradient colors same as SchoolCodeVerification


    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.purple.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          BouncingBubble(
            size: 60,
            left: width * 0.2,
            top: height * 0.1,
            color: Colors.purple,
          ),
          BouncingBubble(
            size: 80,
            left: width * 0.7,
            top: height * 0.2,
            color: Colors.blue,
            bounceHeight: 20, // optional
            duration: Duration(seconds: 3), // optional
          ),
          BouncingBubble(
            size: 40,
            left: width * 0.5,
            top: height * 0.33,
            color: Colors.purpleAccent,
          ),
          BouncingBubble(
            size: 50,
            left: width * 0.1,
            top: height * 0.5,
            color: Colors.blueAccent,
          ),

          BouncingBubble(
            size: 60,
            left: width * 0.1,
            top: height * 0.9,
            color: Colors.purple,
          ),
          BouncingBubble(
            size: 80,
            left: width * 0.4,
            top: height * 0.8,
            color: Colors.blue,
          ),
          BouncingBubble(
            size: 40,
            left: width * 0.6,
            top: height * 0.7,
            color: Colors.purpleAccent,
          ),
          BouncingBubble(
            size: 50,
            left: width * 0.8,
            top: height * 0.9,
            color: Colors.blueAccent,
          ),


          // Center logo + progress
          Center(
            child: FadeTransition(
              opacity: _fadeIn,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: "app_logo",
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade400, Colors.cyan.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/logos/digivity_logo.png",
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "DIGIVITY ETAB TEACHER APP",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Empowering Education Through Innovation",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Linear progress bar
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return SizedBox(
                        width: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _progressController.value,
                            backgroundColor: Colors.white24,
                            valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 6,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
